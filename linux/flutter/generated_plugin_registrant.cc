//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <animated_rating_stars/animated_rating_stars_plugin.h>
#include <audioplayers_linux/audioplayers_linux_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) animated_rating_stars_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AnimatedRatingStarsPlugin");
  animated_rating_stars_plugin_register_with_registrar(animated_rating_stars_registrar);
  g_autoptr(FlPluginRegistrar) audioplayers_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
  audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
}
