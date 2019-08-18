project(
    'io.elementary.keytutor',
    'vala', 'c',
    version: '0.1.0'
)

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language:'c'
)

asresources = gnome.compile_resources(
    'as-resources',
    join_paths('data', meson.project_name() + '.gresource.xml'),
    source_dir: 'data',
    c_name: 'as'
)

dep_gtk3 = dependency('gtk+-3.0')
dep_granite = dependency('granite')
dep_json = dependency('json-glib-1.0')

subdir ('src')
