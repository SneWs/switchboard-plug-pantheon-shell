/*
* Copyright (c) 2018 elementary, Inc. (https://elementary.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

public class Appearance : Gtk.Grid {
    private const string CSS = """
        .blueberry {
            background-color: @BLUEBERRY_300;
            border-color: @BLUEBERRY_500;
            color: transparent;
        }

        .slate {
            background-color: @SLATE_300;
            border-color: @SLATE_500;
            color: transparent;
        }

        .circular:checked {
            border-width: 4px;
        }
    """;
    private const string INTERFACE_SCHEMA = "org.gnome.desktop.interface";
    private const string PANEL_SCHEMA = "io.elementary.desktop.wingpanel";
    private const string STYLESHEET_KEY = "gtk-theme";

    private Gtk.Grid accent_grid;
    private Gtk.ToggleButton blueberry_button;
    private Gtk.ToggleButton slate_button;

    construct {
        column_spacing = 12;
        halign = Gtk.Align.CENTER;
        row_spacing = 6;
        margin_start = margin_end = 6;

        var accent_label = new Gtk.Label (_("Accent color:"));
        accent_label.halign = Gtk.Align.END;

        accent_grid = new Gtk.Grid ();
        accent_grid.column_spacing = 6;

        blueberry_button = new Gtk.ToggleButton ();
        blueberry_button.tooltip_text = _("Blueberry");
        blueberry_button.width_request = blueberry_button.height_request = 24;
        blueberry_button.get_style_context ().add_class ("circular");
        blueberry_button.get_style_context ().add_class ("blueberry");

        slate_button = new Gtk.ToggleButton ();
        slate_button.tooltip_text = _("Slate");
        slate_button.width_request = slate_button.height_request = 24;
        slate_button.get_style_context ().add_class ("circular");
        slate_button.get_style_context ().add_class ("slate");

        accent_grid.attach (blueberry_button, 0, 0);
        accent_grid.attach (slate_button,     1, 0);

        var contrast_label = new Gtk.Label (_("High contrast theme:"));
        var contrast_switch = new Gtk.Switch ();

        attach (accent_label,    0, 0);
        attach (accent_grid,     1, 0);
        attach (contrast_label,  0, 1);
        attach (contrast_switch, 1, 1);

        var provider = new Gtk.CssProvider ();
        try {
            provider.load_from_data (CSS, CSS.length);

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        } catch (GLib.Error e) {
            return;
        }

        var interface_settings = new GLib.Settings (INTERFACE_SCHEMA);

        var current_stylesheet = interface_settings.get_string (STYLESHEET_KEY);
        if (current_stylesheet == "elementary") {
            blueberry_button.active = true;
        } else if (current_stylesheet == "elementary-slate") {
            slate_button.active = true;
        } else if (current_stylesheet == "HighContrast") {
            contrast_switch.active = true;
            accent_grid.sensitive = false;
        }

        var panel_schema = SettingsSchemaSource.get_default ().lookup (PANEL_SCHEMA, false);
        if (panel_schema != null) {
            var transparent_label = new Gtk.Label (_("Panel transparency:"));
            var transparent_switch = new Gtk.Switch ();
            
            attach (transparent_label, 0, 2);
            attach (transparent_switch, 1, 2);

            var panel_settings = new Settings (PANEL_SCHEMA);
            panel_settings.bind ("use-transparency", transparent_switch, "active", SettingsBindFlags.DEFAULT);
        }

        blueberry_button.clicked.connect (() => {
            if (blueberry_button.active) {
                slate_button.active = false;

                blueberry_button.sensitive = false;
                slate_button.sensitive = true;

                interface_settings.set_string (STYLESHEET_KEY, "elementary");
            }
        });

        slate_button.clicked.connect (() => {
            if (slate_button.active) {
                blueberry_button.active = false;

                slate_button.sensitive = false;
                blueberry_button.sensitive = true;

                interface_settings.set_string (STYLESHEET_KEY, "elementary-slate");
            }
        });

        contrast_switch.notify["active"].connect (() => {
            if (contrast_switch.active) {
                interface_settings.set_string (STYLESHEET_KEY, "HighContrast");
                accent_grid.sensitive = false;
            } else {
                interface_settings.set_string (STYLESHEET_KEY, get_selected_accent_theme ());
                accent_grid.sensitive = true;
            }
        });
    }

    private string get_selected_accent_theme () {
        if (slate_button.active) return "elementary-slate";
        return "elementary";
    }
}

