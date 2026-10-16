#ifdef ISSCONFIG_CODE
#ifndef ISSCONFIG_CONFIG_INCLUDED
#error Include issconfig.iss before [Setup] before including its code pass
#endif
#ifndef ISSCONFIG_CODE_INCLUDED
#define ISSCONFIG_CODE_INCLUDED
#include "internal/theme.iss"
#include "internal/layout.iss"
#include "internal/folder-browser.iss"
#include "internal/action-pages.iss"

procedure IssConfigInitialize;
begin
  IssConfigInitializeTheme;
#if IssConfigCompact
  IssConfigInitializeLayout;
#endif
#if IssConfigFolderBrowser
  IssConfigInitializeFolderBrowser;
#endif
end;

procedure IssConfigPageChanged(PageID: Integer);
begin
#if IssConfigCompact
  IssConfigUpdatePage(PageID);
#endif
  IssConfigUpdateActionPage(PageID);
end;

procedure IssConfigShutdown;
begin
  IssConfigShutdownTheme;
end;
#endif
#else
#ifndef ISSCONFIG_CONFIG_INCLUDED
#define ISSCONFIG_CONFIG_INCLUDED
#ifndef IssConfigDarkBackground
#define IssConfigDarkBackground "171717"
#endif
#ifndef IssConfigDarkSurface
#define IssConfigDarkSurface "252525"
#endif
#ifndef IssConfigDarkText
#define IssConfigDarkText "F5F5F5"
#endif
#ifndef IssConfigDarkBorder
#define IssConfigDarkBorder "404040"
#endif
#ifndef IssConfigDarkButton
#define IssConfigDarkButton "383838"
#endif
#ifndef IssConfigDarkHover
#define IssConfigDarkHover "484848"
#endif
#ifndef IssConfigDarkPressed
#define IssConfigDarkPressed "303030"
#endif
#ifndef IssConfigDarkDisabled
#define IssConfigDarkDisabled "303030"
#endif
#ifndef IssConfigDarkMuted
#define IssConfigDarkMuted "777777"
#endif
#ifndef IssConfigLightBackground
#define IssConfigLightBackground "F5F5F5"
#endif
#ifndef IssConfigLightSurface
#define IssConfigLightSurface "FFFFFF"
#endif
#ifndef IssConfigLightText
#define IssConfigLightText "171717"
#endif
#ifndef IssConfigLightBorder
#define IssConfigLightBorder "D4D4D4"
#endif
#ifndef IssConfigLightButton
#define IssConfigLightButton "E5E5E5"
#endif
#ifndef IssConfigLightHover
#define IssConfigLightHover "D4D4D4"
#endif
#ifndef IssConfigLightPressed
#define IssConfigLightPressed "C5C5C5"
#endif
#ifndef IssConfigLightDisabled
#define IssConfigLightDisabled "ECECEC"
#endif
#ifndef IssConfigLightMuted
#define IssConfigLightMuted "909090"
#endif
#ifndef IssConfigAccent
#define IssConfigAccent "00B9E8"
#endif
#ifndef IssConfigAccentHover
#define IssConfigAccentHover "65D8F4"
#endif
#ifndef IssConfigAccentPressed
#define IssConfigAccentPressed "009DC5"
#endif
#ifndef IssConfigAccentText
#define IssConfigAccentText "000000"
#endif
#ifndef IssConfigLightScrollbar
#define IssConfigLightScrollbar "AAAAAA"
#endif
#ifndef IssConfigLightScrollbarHover
#define IssConfigLightScrollbarHover "909090"
#endif
#ifndef IssConfigWizardStyle
#define IssConfigWizardStyle "modern dynamic hidebevels"
#endif
#ifndef IssConfigHeightPercent
#define IssConfigHeightPercent 70
#endif
#ifndef IssConfigMargin
#define IssConfigMargin 24
#endif
#ifndef IssConfigHeaderHeight
#define IssConfigHeaderHeight 88
#endif
#ifndef IssConfigPathHeight
#define IssConfigPathHeight 36
#endif
#ifndef IssConfigButtonHeight
#define IssConfigButtonHeight 32
#endif
#ifndef IssConfigCompact
#define IssConfigCompact 1
#endif
#ifndef IssConfigFolderBrowser
#define IssConfigFolderBrowser 1
#endif
#ifndef IssConfigHeading
#define IssConfigHeading "Install application"
#endif
#ifndef IssConfigIntroduction
#define IssConfigIntroduction "Choose where to install the application."
#endif
#ifndef IssConfigFolderLabel
#define IssConfigFolderLabel "Installation folder"
#endif
#ifndef IssConfigSupportText
#define IssConfigSupportText ""
#endif
#ifndef IssConfigFolderSuffix
#define IssConfigFolderSuffix ""
#endif
#ifndef IssConfigBrowserTitle
#define IssConfigBrowserTitle "Choose installation folder"
#endif
#ifndef IssConfigBrowserHint
#define IssConfigBrowserHint "Select a folder or enter an installation path."
#endif

; Keep Inno's native surfaces and the custom-painted controls on one palette.
[Setup]
WizardStyle={#IssConfigWizardStyle}
WizardBackColor=#{#IssConfigLightBackground}
WizardBackColorDynamicDark=#{#IssConfigDarkBackground}
WizardImageBackColor=#{#IssConfigLightBackground}
WizardImageBackColorDynamicDark=#{#IssConfigDarkBackground}
WizardSmallImageBackColor=none
WizardSmallImageBackColorDynamicDark=none

[CustomMessages]
IssConfigHeading={#IssConfigHeading}
IssConfigIntroduction={#IssConfigIntroduction}
IssConfigFolderLabel={#IssConfigFolderLabel}
IssConfigSupportText={#IssConfigSupportText}
IssConfigFolderSuffix={#IssConfigFolderSuffix}
IssConfigBrowserTitle={#IssConfigBrowserTitle}
IssConfigBrowserHint={#IssConfigBrowserHint}
#endif
#endif
