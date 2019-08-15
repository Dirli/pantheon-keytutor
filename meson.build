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

dep_gtk3 = dependency('gtk+-3.0')

subdir ('src')
