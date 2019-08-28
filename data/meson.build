install_data(meson.project_name() +'.gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0/schemas')
)

locale_list = ['en', 'ru']

foreach i : locale_list
    install_data(
        join_paths('layout', i + '.json'),
        install_dir: join_paths(get_option('datadir'), meson.project_name(), 'layout')
    )
endforeach
