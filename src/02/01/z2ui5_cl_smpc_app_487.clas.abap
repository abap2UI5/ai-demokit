" @keywords panel sap.m panelsticky text
" @summary Panels can also have a sticky header. [since rel. 1.117]
CLASS z2ui5_cl_smpc_app_487 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_487 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Panel`
            )->a( n = `expandable`   v = `true`
            )->a( n = `expanded`     v = `true`
            )->a( n = `stickyHeader` v = `true`
            )->a( n = `height`       v = `500px`
            )->a( n = `headerText`   v = `Panel with a sticky header`
            )->a( n = `width`        v = `auto`
            )->a( n = `class`        v = `sapUiResponsiveMargin`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `id`         v = `expandablePanel`
            )->a( n = `expanded`   v = `true`
            )->a( n = `expandable` v = `true`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`
            )->a( n = `headerText` v = `Panel without sticky header`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Lipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut aliquam ` &&
                                      `purus sit amet. Sed arcu non odio euismod lacinia at. Posuere lorem ipsum dolor sit amet consectetur adipiscing. Gravida quis ` &&
                                      `blandit turpis cursus in hac habitasse. Non pulvinar neque laoreet suspendisse interdum. Et netus et malesuada fames ac turpis ` &&
                                      `egestas. Luctus accumsan tortor posuere ac ut consequat semper. Nibh praesent tristique magna sit amet purus gravida quis blandit.` &&
                                      ` Malesuada nunc vel risus commodo.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Euismod lacinia at quis risus. Ac auctor augue mauris augue neque gravida in. Rhoncus est pellentesque elit ullamcorper dignissim ` &&
                                      `cras. Et egestas quis ipsum suspendisse ultrices gravida dictum. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. ` &&
                                      `Sem et tortor consequat id porta nibh venenatis cras. Euismod lacinia at quis risus sed. Odio tempor orci dapibus ultrices. ` &&
                                      `Pellentesque eu tincidunt tortor aliquam. Arcu vitae elementum curabitur vitae nunc sed. Tincidunt augue interdum velit euismod in` &&
                                      ` pellentesque. Ac turpis egestas maecenas pharetra convallis posuere morbi leo urna. Turpis egestas maecenas pharetra convallis ` &&
                                      `posuere morbi leo. Lectus proin nibh nisl condimentum. Turpis cursus in hac habitasse. Ac turpis egestas sed tempus urna et ` &&
                                      `pharetra pharetra massa. Egestas tellus rutrum tellus pellentesque eu. Platea dictumst vestibulum rhoncus est pellentesque elit ` &&
                                      `ullamcorper dignissim cras. Pellentesque elit eget gravida cum sociis natoque. Vulputate dignissim suspendisse in est ante.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `In dictum non consectetur a erat nam at. Velit laoreet id donec ultrices tincidunt arcu non. Fermentum odio eu feugiat pretium ` &&
                                      `nibh ipsum consequat nisl vel. Vitae semper quis lectus nulla at volutpat. In tellus integer feugiat scelerisque varius morbi enim` &&
                                      ` nunc. Tincidunt augue interdum velit euismod in. Turpis cursus in hac habitasse platea dictumst quisque sagittis. Nec feugiat ` &&
                                      `nisl pretium fusce id velit ut. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Elementum pulvinar etiam non quam.` &&
                                      ` Ac ut consequat semper viverra nam libero justo laoreet. Suscipit adipiscing bibendum est ultricies integer quis auctor elit. ` &&
                                      `Tincidunt ornare massa eget egestas purus viverra accumsan in nisl. Arcu odio ut sem nulla pharetra diam. Ut enim blandit volutpat` &&
                                      ` maecenas volutpat blandit aliquam etiam erat. Lorem donec massa sapien faucibus et molestie ac.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Neque convallis a cras semper. Nam libero justo laoreet sit amet cursus. Aenean pharetra magna ac placerat vestibulum lectus ` &&
                                      `mauris ultrices eros. Posuere morbi leo urna molestie at elementum eu facilisis sed. Nunc non blandit massa enim. Velit dignissim ` &&
                                      `sodales ut eu sem integer vitae justo. Massa id neque aliquam vestibulum morbi blandit. Eget felis eget nunc lobortis mattis. Ut ` &&
                                      `eu sem integer vitae justo eget. Aenean et tortor at risus viverra. Sodales ut eu sem integer vitae justo eget magna. Ultrices dui` &&
                                      ` sapien eget mi proin. Sodales ut eu sem integer vitae justo eget magna. Risus in hendrerit gravida rutrum quisque non. Amet est ` &&
                                      `placerat in egestas erat imperdiet sed euismod nisi. Mi tempus imperdiet nulla malesuada pellentesque elit eget gravida. A diam ` &&
                                      `sollicitudin tempor id eu nisl nunc mi.`
                )->tag( `Text`
                    )->a( n = `class` v = `sapUiResponsiveMargin`
                    )->a( n = `text`  v = `Dui vivamus arcu felis bibendum ut tristique et. A diam sollicitudin tempor id eu. Elementum facilisis leo vel fringilla. ` &&
                                      `Porttitor massa id neque aliquam vestibulum morbi blandit cursus. Non quam lacus suspendisse faucibus interdum posuere lorem ` &&
                                      `ipsum. Massa massa ultricies mi quis hendrerit dolor magna eget est. Aliquet enim tortor at auctor urna nunc id. Ac orci phasellus` &&
                                      ` egestas tellus rutrum tellus pellentesque eu tincidunt. Velit euismod in pellentesque massa. Et netus et malesuada fames ac ` &&
                                      `turpis egestas maecenas. Scelerisque varius morbi enim nunc faucibus a pellentesque. Neque gravida in fermentum et sollicitudin ac` &&
                                      ` orci phasellus egestas. Ultricies lacus sed turpis tincidunt id aliquet risus. Urna id volutpat lacus laoreet. Malesuada fames ac` &&
                                      ` turpis egestas maecenas. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Donec pretium vulputate sapien nec ` &&
                                      `sagittis. Sodales ut eu sem integer vitae justo eget magna. In fermentum posuere urna nec tincidunt praesent semper feugiat. ` &&
                                      `Ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
