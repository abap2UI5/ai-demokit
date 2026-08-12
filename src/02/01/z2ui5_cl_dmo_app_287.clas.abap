CLASS z2ui5_cl_dmo_app_287 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        text    TYPE string,
        key     TYPE string,
        content TYPE string,
        badge   TYPE abap_bool,
      END OF ty_s_tab.
    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA t_tabs      TYPE ty_t_tab.
    DATA density_idx TYPE i.
    DATA tab_density TYPE string VALUE `Cozy`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_287 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " onTabDensityModeSelect sets tabDensityMode on all nine bars from the
    " selected radio button's text; tabDensityMode is a bindable property, so
    " every bar binds the one server-side field instead (see on_event)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`

        )->open( `Panel`

            )->open( n = `SimpleForm` ns = `f`
                )->a( n = `editable`     v = `true`
                )->a( n = `labelSpanXL`  v = `2`
                )->a( n = `labelSpanL`   v = `2`
                )->a( n = `labelSpanM`   v = `3`
                )->a( n = `labelSpanS`   v = `5`
                )->a( n = `layout`       v = `ResponsiveGridLayout`

                )->leaf( `Label`
                    )->a( n = `text` v = `Tab Density Mode`

                )->open( `RadioButtonGroup`
                    )->a( n = `columns`       v = `3`
                    )->a( n = `selectedIndex` v = client->_bind( density_idx )
                    )->a( n = `select`        v = client->_event( `DENSITY` )

                    )->leaf( `RadioButton`
                        )->a( n = `text` v = `Cozy`
                    )->leaf( `RadioButton`
                        )->a( n = `text` v = `Compact`
                    )->leaf( `RadioButton`
                        )->a( n = `text` v = `Inherit`

                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`                  v = `iconTabBar0`
                )->a( n = `enableTabReordering` v = `true`
                )->a( n = `tabDensityMode`      v = client->_bind( tab_density )
                )->a( n = `class`               v = `sapUiResponsiveContentPadding`
                )->a( n = `items`               v = client->_bind( t_tabs )

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `{TEXT}`
                        )->a( n = `key`  v = `{KEY}`

                        )->leaf( `Text`
                            )->a( n = `text` v = `{CONTENT}`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `{BADGE}`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar1`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Info`
                        )->a( n = `key`  v = `info`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Info content goes here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Attachments`
                        )->a( n = `key`  v = `attachments`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Attachments go here ...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Notes`
                        )->a( n = `key`  v = `notes`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Notes go here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `People`
                        )->a( n = `key`  v = `people`

                        )->leaf( `Text`
                            )->a( n = `text` v = `People content goes here ...`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar2`
                )->a( n = `headerMode`     v = `Inline`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`  v = `sap-icon://process`
                        )->a( n = `count` v = `3`
                        )->a( n = `text`  v = `Info`
                        )->a( n = `key`   v = `info`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Info content goes here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon`  v = `sap-icon://attachment`
                        )->a( n = `count` v = `4321`
                        )->a( n = `text`  v = `Attachments`
                        )->a( n = `key`   v = `attachments`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Attachments go here ...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon`  v = `sap-icon://notes`
                        )->a( n = `count` v = `333`
                        )->a( n = `text`  v = `Notes`
                        )->a( n = `key`   v = `notes`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Notes go here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon`  v = `sap-icon://hint`
                        )->a( n = `count` v = `34`
                        )->a( n = `text`  v = `People`
                        )->a( n = `key`   v = `people`

                        )->leaf( `Text`
                            )->a( n = `text` v = `People content goes here ...`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar3`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `count` v = `3`
                        )->a( n = `text`  v = `Info`
                        )->a( n = `key`   v = `info`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Info content goes here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `count` v = `4321`
                        )->a( n = `text`  v = `Attachments`
                        )->a( n = `key`   v = `attachments`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Attachments go here ...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `count` v = `333`
                        )->a( n = `text`  v = `Notes`
                        )->a( n = `key`   v = `notes`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Notes go here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `count` v = `34`
                        )->a( n = `text`  v = `People`
                        )->a( n = `key`   v = `people`

                        )->leaf( `Text`
                            )->a( n = `text` v = `People content goes here ...`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar4`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `icon` v = `sap-icon://hint`
                        )->a( n = `key`  v = `info`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Info content goes here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon`  v = `sap-icon://attachment`
                        )->a( n = `count` v = `3`
                        )->a( n = `key`   v = `attachments`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Attachments go here ...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon`  v = `sap-icon://notes`
                        )->a( n = `count` v = `12`
                        )->a( n = `key`   v = `notes`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Notes go here ...`

                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon` v = `sap-icon://group`
                        )->a( n = `key`  v = `people`

                        )->leaf( `Text`
                            )->a( n = `text` v = `People content goes here ...`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar5`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://hint`
                        )->a( n = `iconColor` v = `Critical`
                        )->a( n = `key`       v = `info`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Info content goes here ...`

                    )->shut(

                    )->leaf( `IconTabSeparator`
                        )->a( n = `icon` v = ``

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://attachment`
                        )->a( n = `iconColor` v = `Neutral`
                        )->a( n = `count`     v = `3`
                        )->a( n = `key`       v = `attachments`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Attachments go here ...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->leaf( `IconTabSeparator`
                        )->a( n = `icon` v = `sap-icon://vertical-grip`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://notes`
                        )->a( n = `iconColor` v = `Positive`
                        )->a( n = `count`     v = `12`
                        )->a( n = `key`       v = `notes`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Notes go here ...`

                    )->shut(

                    )->leaf( `IconTabSeparator`
                        )->a( n = `icon` v = `sap-icon://process`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://group`
                        )->a( n = `iconColor` v = `Negative`
                        )->a( n = `key`       v = `people`

                        )->leaf( `Text`
                            )->a( n = `text` v = `People content goes here ...`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar6`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://begin`
                        )->a( n = `iconColor` v = `Positive`
                        )->a( n = `design`    v = `Horizontal`
                        )->a( n = `count`     v = `53 of 123`
                        )->a( n = `text`      v = `Confirm Ok`
                        )->a( n = `key`       v = `Ok`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Filtered items goes here ...`

                    )->shut(

                    )->leaf( `IconTabSeparator`
                        )->a( n = `icon` v = `sap-icon://open-command-field`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://compare`
                        )->a( n = `iconColor` v = `Critical`
                        )->a( n = `design`    v = `Horizontal`
                        )->a( n = `count`     v = `51 of 123`
                        )->a( n = `text`      v = `Check Heavys`
                        )->a( n = `key`       v = `Heavy`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->leaf( `IconTabSeparator`
                        )->a( n = `icon` v = `sap-icon://open-command-field`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://inventory`
                        )->a( n = `iconColor` v = `Negative`
                        )->a( n = `design`    v = `Horizontal`
                        )->a( n = `count`     v = `19 of 123`
                        )->a( n = `text`      v = `Claim Overweights`
                        )->a( n = `key`       v = `Overweight`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar7`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `showAll` v = `true`
                        )->a( n = `count`   v = `123`
                        )->a( n = `text`    v = `Products`
                        )->a( n = `key`     v = `All`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Filtered items goes here ...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->leaf( `IconTabSeparator`

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://begin`
                        )->a( n = `iconColor` v = `Positive`
                        )->a( n = `count`     v = `53`
                        )->a( n = `text`      v = `Ok`
                        )->a( n = `key`       v = `Ok`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://compare`
                        )->a( n = `iconColor` v = `Critical`
                        )->a( n = `count`     v = `51`
                        )->a( n = `text`      v = `Heavy`
                        )->a( n = `key`       v = `Heavy`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `icon`      v = `sap-icon://inventory`
                        )->a( n = `iconColor` v = `Negative`
                        )->a( n = `count`     v = `19`
                        )->a( n = `text`      v = `Overweight`
                        )->a( n = `key`       v = `Overweight`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `IconTabBar`
                )->a( n = `id`             v = `iconTabBar8`
                )->a( n = `tabDensityMode` v = client->_bind( tab_density )
                )->a( n = `class`          v = `sapUiResponsiveContentPadding`

                )->open( `items`

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Info`
                        )->a( n = `key`  v = `info`

                        )->open( `items`

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Info one`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Info one content goes here...`

                            )->shut(

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Info two`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Info two content goes here...`

                                )->open( `customData`
                                    )->leaf( `BadgeCustomData`
                                        )->a( n = `visible` v = `true`

                                )->shut(
                            )->shut(

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Info three with badge`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Info three content goes here...`

                                )->open( `customData`
                                    )->leaf( `BadgeCustomData`
                                        )->a( n = `visible` v = `true`

                                )->shut(
                            )->shut(

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Info four`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Info four content goes here...`

                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Attachments`
                        )->a( n = `key`  v = `attachments`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Attachments own content goes here...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(

                        )->open( `items`

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Attachment one`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Attachment one goes here...`

                            )->shut(

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Attachment two`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Attachment two goes here...`

                            )->shut(
                        )->shut(
                    )->shut(

                    )->open( `IconTabFilter`
                        )->a( n = `text` v = `Notes`
                        )->a( n = `key`  v = `notes`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Notes own content goes here...`

                        )->open( `customData`
                            )->leaf( `BadgeCustomData`
                                )->a( n = `visible` v = `true`

                        )->shut(

                        )->open( `items`

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Note one`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Note one goes here...`

                            )->shut(

                            )->open( `IconTabFilter`
                                )->a( n = `text` v = `Note two`

                                )->leaf( `Text`
                                    )->a( n = `text` v = `Note two goes here...`

                                )->open( `customData`
                                    )->leaf( `BadgeCustomData`
                                        )->a( n = `visible` v = `true`

                                )->shut(
                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `DENSITY`.
        " the original reads the selected button's TEXT; the group's
        " selectedIndex is bound two-way, so the same three values are derived
        " server-side and every bar follows through its tabDensityMode binding
        tab_density = SWITCH string( density_idx
                                     WHEN 0 THEN `Cozy`
                                     WHEN 1 THEN `Compact`
                                     WHEN 2 THEN `Inherit` ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " onInit adds 30 IconTabFilters to iconTabBar0, the 19th carrying a badge
    DO 30 TIMES.
      t_tabs = VALUE #( BASE t_tabs
        ( text    = |Tab { sy-index }|
          key     = |{ sy-index }|
          content = |Content { sy-index }|
          badge   = xsdbool( sy-index = 19 ) ) ).
    ENDDO.

  ENDMETHOD.

ENDCLASS.
