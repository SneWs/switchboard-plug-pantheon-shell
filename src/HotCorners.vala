/*
* Copyright (c) 2011-2016 elementary LLC. (http://launchpad.net/switchboard-plug-pantheon-shell)
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
* Free Software Foundation, Inc., 59 Temple Place - Suite 330,
* Boston, MA 02111-1307, USA.
*
* Authored by: Tom Beckmann
*/

public class HotCorners : Gtk.Grid {
    construct {
        expand = true;
        column_spacing = 12;
        margin = 32;
        margin_top = 48;

        var expl = new Gtk.Label (_("When the cursor enters the corner of the display:"));
        expl.halign = Gtk.Align.START;
        expl.hexpand = true;
        expl.margin_bottom = 10;

        var topleft = create_hotcorner ();
        topleft.active_id = BehaviorSettings.get_default ().schema.get_enum ("hotcorner-topleft").to_string ();
        topleft.changed.connect (() => BehaviorSettings.get_default ().schema.set_enum ("hotcorner-topleft", int.parse (topleft.active_id)));
        topleft.valign = Gtk.Align.START;

        var topright = create_hotcorner ();
        topright.active_id = BehaviorSettings.get_default ().schema.get_enum ("hotcorner-topright").to_string ();
        topright.changed.connect (() => BehaviorSettings.get_default ().schema.set_enum ("hotcorner-topright", int.parse (topright.active_id)));
        topright.valign = Gtk.Align.START;

        var bottomleft = create_hotcorner ();
        bottomleft.active_id = BehaviorSettings.get_default ().schema.get_enum ("hotcorner-bottomleft").to_string ();
        bottomleft.changed.connect (() => BehaviorSettings.get_default ().schema.set_enum ("hotcorner-bottomleft", int.parse (bottomleft.active_id)));
        bottomleft.valign = Gtk.Align.END;

        var bottomright = create_hotcorner ();
        bottomright.active_id = BehaviorSettings.get_default ().schema.get_enum ("hotcorner-bottomright").to_string ();
        bottomright.changed.connect (() => BehaviorSettings.get_default ().schema.set_enum ("hotcorner-bottomright", int.parse (bottomright.active_id)));
        bottomright.valign = Gtk.Align.END;

        var icon = new Gtk.Image.from_file (Constants.PKGDATADIR + "/hotcornerdisplay.svg");
        icon.get_style_context ().add_class ("hotcorner-display");
        icon.expand = true;

        var custom_command = new Gtk.Entry ();
        custom_command.text = BehaviorSettings.get_default ().hotcorner_custom_command;
        custom_command.changed.connect (() => BehaviorSettings.get_default ().hotcorner_custom_command = custom_command.text );
        
        var cc_label = new Gtk.Label (_("Custom command:"));
        cc_label.set_halign (Gtk.Align.START);
        
        var cc_grid = new Gtk.Grid ();
        cc_grid.column_spacing = 12;
        cc_grid.expand = true;
        cc_grid.margin_top = 48;
        cc_grid.attach (cc_label, 0, 0, 1, 1);
        cc_grid.attach (custom_command, 1, 0, 1, 1);

        attach (expl, 0, 0, 3, 1);
        attach (icon, 1, 1, 1, 3);
        attach (topleft, 0, 1, 1, 1);
        attach (topright, 2, 1, 1, 1);
        attach (bottomleft, 0, 3, 1, 1);
        attach (bottomright, 2, 3, 1, 1);
        attach (cc_grid, 0, 4, 2, 1);
    }

    private Gtk.ComboBoxText create_hotcorner () {
        var box = new Gtk.ComboBoxText ();
        box.append ("0", _("Do nothing"));              // none
        box.append ("1", _("Multitasking View"));       // show-workspace-view
        box.append ("2", _("Maximize current window")); // maximize-current
        box.append ("3", _("Minimize current window")); // minimize-current
        box.append ("4", _("Show Applications Menu"));  // open-launcher
        box.append ("7", _("Show all windows"));        // window-overview-all
        box.append ("5", _("Execute custom command"));  // custom-command

        return box;
    }
}