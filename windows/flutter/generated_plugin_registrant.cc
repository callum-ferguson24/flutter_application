//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <app_links/app_links_plugin_c_api.h>
#include <awesome_notifications/awesome_notifications_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AppLinksPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AppLinksPluginCApi"));
  AwesomeNotificationsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AwesomeNotificationsPluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
