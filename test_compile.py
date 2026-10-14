"""Compile standalone examples without installing or launching them."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parent
ISCC = os.environ.get("ISCC") or shutil.which("iscc")
if not ISCC and os.name == "nt":
    candidate = Path(os.environ.get("ProgramFiles(x86)", "C:/Program Files (x86)")) / "Inno Setup 6/ISCC.exe"
    if candidate.is_file():
        ISCC = str(candidate)


@unittest.skipUnless(ISCC, "Inno Setup compiler required")
class CompileTests(unittest.TestCase):
    def test_standalone_configurations(self):
        variants = [
            [],
            ["/DIssConfigCompact=0", "/DIssConfigFolderBrowser=0"],
            ["/DIssConfigFolderBrowser=0"],
            ["/DIssConfigCompact=0"],
            ["/DIssConfigFolderSuffix=", "/DIssConfigPathHeight=40", "/DIssConfigButtonHeight=36"],
        ]
        for defines in variants:
            with self.subTest(defines=defines), tempfile.TemporaryDirectory() as temp:
                # Copy only the library: catches accidental dependencies on its host app.
                library = Path(temp) / "issconfig"
                shutil.copytree(ROOT, library, ignore=shutil.ignore_patterns("output", "__pycache__", ".git"))
                result = subprocess.run(
                    [ISCC, "/Q", *defines, "examples/minimal.iss"], cwd=library,
                    capture_output=True, text=True, timeout=30,
                )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertGreater((library / "examples/output/example-notes-setup.exe").stat().st_size, 0)


if __name__ == "__main__":
    unittest.main()
