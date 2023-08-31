import sublime
import sublime_plugin

# https://docs.sublimetext.io/guide/extensibility/plugins
# https://forum.sublimetext.com/t/disable-minimap-preference/57770/4
class ShowMinimapSetting(sublime_plugin.EventListener):
	def on_activated(self, view):
		show_minimap = view.settings().get("show_minimap")
		if isinstance(show_minimap, bool):
			view.window().set_minimap_visible(show_minimap)
