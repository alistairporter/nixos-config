{
  lib,
  ...
}:
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/nautilus/preferences" = {
      date-time-format = "detailed";
      default-folder-viewer = "list-view";
      fts-enabled = false;
      migrated-gtk-settings = true;
      recursive-search = "always";
      search-filter-time-type = "last_modified";
      show-create-link = true;
      show-delete-permanently = false;
      show-directory-item-counts = "always";
      show-image-thumbnails = "always";
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 200;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 200;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
    };
  };
}
