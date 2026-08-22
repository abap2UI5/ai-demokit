" @keywords icontabbar icon tab bar sap.m icontabbartabdensitymode panel label radiobuttongroup radiobutton icontabfilter text
" @summary In this example, the Icon Tab Bar is used in different tab density modes.
CLASS z2ui5_cl_smpc_app_620 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_tab,
             key     TYPE string,
             text    TYPE string,
             icon    TYPE string,
             content TYPE string,
           END OF ty_s_tab.
    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    " the two bars the controller fills in JavaScript
    DATA t_tabs        TYPE ty_t_tab.
    DATA t_inline_tabs TYPE ty_t_tab.

    " the RadioButtonGroup writes this; eight of the nine bars bind it
    DATA density_idx  TYPE i.
    DATA density_mode TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_620 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(bars) = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`

        )->ele( `Panel` ).

    bars->ele( n = `SimpleForm` ns = `f`
        )->a( n = `editable`    v = `true`
        )->a( n = `labelSpanXL` v = `2`
        )->a( n = `labelSpanL`  v = `2`
        )->a( n = `labelSpanM`  v = `3`
        )->a( n = `labelSpanS`  v = `5`
        )->a( n = `layout`      v = `ResponsiveGridLayout`

        )->tag( `Label`
            )->a( n = `text` v = `Tab Density Mode`
        " onTabDensityModeSelect reads the picked button's TEXT and hands it to
        " eight setters; the group writes its index and one round trip turns
        " that into the enum the eight bars bind (app 604/617 idiom)
        )->ele( `RadioButtonGroup`
            )->a( n = `columns`       v = `3`
            )->a( n = `selectedIndex` v = client->_bind( density_idx )
            )->a( n = `select`        v = client->_event( `DENSITY` )
            )->tag( `RadioButton`
                )->a( n = `text` v = `Cozy`
            )->tag( `RadioButton`
                )->a( n = `text` v = `Compact`
            )->tag( `RadioButton`
                )->a( n = `text` v = `Inherit`
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar0`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        )->a( n = `enableTabReordering` v = `true`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|
        )->a( n = `items` v = client->_bind( t_tabs )

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key`  v = `{KEY}`
                )->a( n = `text` v = `{TEXT}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CONTENT}`
            )->end(
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar3`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `info`
                )->a( n = `text` v = `Info`
                )->tag( `Text`
                    )->a( n = `text` v = `Info content goes here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `attachments`
                )->a( n = `text` v = `Attachments`
                )->tag( `Text`
                    )->a( n = `text` v = `Attachments go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `notes`
                )->a( n = `text` v = `Notes`
                )->tag( `Text`
                    )->a( n = `text` v = `Notes go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `people`
                )->a( n = `text` v = `People`
                )->tag( `Text`
                    )->a( n = `text` v = `People content goes here ...`
            )->end(
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar6`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        )->a( n = `headerMode` v = `Inline`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `info`
                )->a( n = `text` v = `Info`
                )->a( n = `count` v = `3`
                )->tag( `Text`
                    )->a( n = `text` v = `Info content goes here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `attachments`
                )->a( n = `text` v = `Attachments`
                )->a( n = `count` v = `4321`
                )->tag( `Text`
                    )->a( n = `text` v = `Attachments go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `notes`
                )->a( n = `text` v = `Notes`
                )->a( n = `count` v = `333`
                )->tag( `Text`
                    )->a( n = `text` v = `Notes go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `people`
                )->a( n = `text` v = `People`
                )->a( n = `count` v = `34`
                )->tag( `Text`
                    )->a( n = `text` v = `People content goes here ...`
            )->end(
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar7`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `info`
                )->a( n = `text` v = `Info`
                )->a( n = `count` v = `3`
                )->tag( `Text`
                    )->a( n = `text` v = `Info content goes here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `attachments`
                )->a( n = `text` v = `Attachments`
                )->a( n = `count` v = `4321`
                )->tag( `Text`
                    )->a( n = `text` v = `Attachments go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `notes`
                )->a( n = `text` v = `Notes`
                )->a( n = `count` v = `333`
                )->tag( `Text`
                    )->a( n = `text` v = `Notes go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `people`
                )->a( n = `text` v = `People`
                )->a( n = `count` v = `34`
                )->tag( `Text`
                    )->a( n = `text` v = `People content goes here ...`
            )->end(
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar4`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `info`
                )->a( n = `icon` v = `sap-icon://hint`
                )->tag( `Text`
                    )->a( n = `text` v = `Info content goes here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `attachments`
                )->a( n = `icon` v = `sap-icon://attachment`
                )->a( n = `count` v = `3`
                )->tag( `Text`
                    )->a( n = `text` v = `Attachments go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `notes`
                )->a( n = `icon` v = `sap-icon://notes`
                )->a( n = `count` v = `12`
                )->tag( `Text`
                    )->a( n = `text` v = `Notes go here ...`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `people`
                )->a( n = `icon` v = `sap-icon://group`
                )->tag( `Text`
                    )->a( n = `text` v = `People content goes here ...`
            )->end(
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar1`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `info`
                )->a( n = `icon` v = `sap-icon://hint`
                )->a( n = `iconColor` v = `Critical`
                )->tag( `Text`
                    )->a( n = `text` v = `Info content goes here ...`
            )->end(
            )->tag( `IconTabSeparator`
                )->a( n = `icon` v = ``
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `attachments`
                )->a( n = `icon` v = `sap-icon://attachment`
                )->a( n = `iconColor` v = `Neutral`
                )->a( n = `count` v = `3`
                )->tag( `Text`
                    )->a( n = `text` v = `Attachments go here ...`
            )->end(
            )->tag( `IconTabSeparator`
                )->a( n = `icon` v = `sap-icon://vertical-grip`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `notes`
                )->a( n = `icon` v = `sap-icon://notes`
                )->a( n = `iconColor` v = `Positive`
                )->a( n = `count` v = `12`
                )->tag( `Text`
                    )->a( n = `text` v = `Notes go here ...`
            )->end(
            )->tag( `IconTabSeparator`
                )->a( n = `icon` v = `sap-icon://process`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `people`
                )->a( n = `icon` v = `sap-icon://group`
                )->a( n = `iconColor` v = `Negative`
                )->tag( `Text`
                    )->a( n = `text` v = `People content goes here ...`
            )->end(
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar2`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `Ok`
                )->a( n = `text` v = `Confirm Ok`
                )->a( n = `icon` v = `sap-icon://begin`
                )->a( n = `iconColor` v = `Positive`
                )->a( n = `count` v = `53 of 123`
                )->a( n = `design` v = `Horizontal`
                )->tag( `Text`
                    )->a( n = `text` v = `Filtered items goes here ...`
            )->end(
            )->tag( `IconTabSeparator`
                )->a( n = `icon` v = `sap-icon://open-command-field`
            )->tag( `IconTabFilter`
                )->a( n = `key` v = `Heavy`
                )->a( n = `text` v = `Check Heavys`
                )->a( n = `icon` v = `sap-icon://compare`
                )->a( n = `iconColor` v = `Critical`
                )->a( n = `count` v = `51 of 123`
                )->a( n = `design` v = `Horizontal`
            )->tag( `IconTabSeparator`
                )->a( n = `icon` v = `sap-icon://open-command-field`
            )->tag( `IconTabFilter`
                )->a( n = `key` v = `Overweight`
                )->a( n = `text` v = `Claim Overweights`
                )->a( n = `icon` v = `sap-icon://inventory`
                )->a( n = `iconColor` v = `Negative`
                )->a( n = `count` v = `19 of 123`
                )->a( n = `design` v = `Horizontal`
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `idIconTabBar5`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        " onTabDensityModeSelect sets tabDensityMode on idIconTabBar0..7;
        " the property is bindable, so all eight share one field
        )->a( n = `tabDensityMode` v = |\{= ${ client->_bind( density_mode ) } \|\| null \}|

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key` v = `All`
                )->a( n = `text` v = `Products`
                )->a( n = `count` v = `123`
                )->a( n = `showAll` v = `true`
                )->tag( `Text`
                    )->a( n = `text` v = `Filtered items goes here ...`
            )->end(
            )->tag( `IconTabSeparator`
            )->tag( `IconTabFilter`
                )->a( n = `key` v = `Ok`
                )->a( n = `text` v = `Ok`
                )->a( n = `icon` v = `sap-icon://begin`
                )->a( n = `iconColor` v = `Positive`
                )->a( n = `count` v = `53`
            )->tag( `IconTabFilter`
                )->a( n = `key` v = `Heavy`
                )->a( n = `text` v = `Heavy`
                )->a( n = `icon` v = `sap-icon://compare`
                )->a( n = `iconColor` v = `Critical`
                )->a( n = `count` v = `51`
            )->tag( `IconTabFilter`
                )->a( n = `key` v = `Overweight`
                )->a( n = `text` v = `Overweight`
                )->a( n = `icon` v = `sap-icon://inventory`
                )->a( n = `iconColor` v = `Negative`
                )->a( n = `count` v = `19`
        )->end(
    )->end( ).

    bars->ele( `IconTabBar`
        )->a( n = `id`    v = `iconTabBarInlineIcons`
        )->a( n = `class` v = `sapUiResponsiveContentPadding`
        )->a( n = `headerMode` v = `Inline`
        )->a( n = `items` v = client->_bind( t_inline_tabs )

        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `key`  v = `{KEY}`
                )->a( n = `text` v = `{TEXT}`
                )->a( n = `icon` v = `{ICON}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CONTENT}`
            )->end(
        )->end(
    )->end( ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `DENSITY`.
      " the three texts ARE the sap.m.IconTabDensityMode members
      density_mode = SWITCH #( density_idx
                               WHEN 0 THEN `Cozy`
                               WHEN 1 THEN `Compact`
                               ELSE        `Inherit` ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the group comes up on its first button, which is what getSelectedButton( )
    " returns before any select
    density_idx  = 0.
    density_mode = `Cozy`.

    " onInit adds thirty tabs to idIconTabBar0 ('Tab n' / 'Content n')
    DO 30 TIMES.
      APPEND VALUE #( key     = |{ sy-index }|
                      text    = |Tab { sy-index }|
                      content = |Content { sy-index }| ) TO t_tabs.
    ENDDO.

    " and twelve to iconTabBarInlineIcons, each with an icon picked at RANDOM
    " from three; a backend cannot draw the browser's numbers, so the three
    " cycle instead (see sidecar)
    DATA(icons) = VALUE string_table( ( `sap-icon://history` )
                                      ( `sap-icon://home` )
                                      ( `sap-icon://employee` ) ).
    DO 12 TIMES.
      APPEND VALUE #( key     = |{ sy-index }|
                      text    = |Tab { sy-index }|
                      icon    = icons[ ( sy-index - 1 ) MOD 3 + 1 ]
                      content = |IconTabBar inline header mode with icons Content { sy-index }| ) TO t_inline_tabs.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
