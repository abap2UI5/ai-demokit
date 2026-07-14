"! Generated overview app - lists every abap2UI5 api sample app in a table.
"! In the Sample column the name links the OpenUI5 source and the ↗ starts the
"! live OpenUI5 sample; in the abap2UI5 column the class name links the generated
"! ABAP class and the ↗ starts the app; Control links the OpenUI5 API - all
"! opening in a new browser tab. Do not edit by hand - regenerate with
"! scripts/generate-overview.mjs
CLASS z2ui5_cl_api_app_overview DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_app,
        module    TYPE string,
        control   TYPE string,
        ctrl_name TYPE string,
        name      TYPE string,
        class     TYPE string,
        path      TYPE string,
        api_url   TYPE string,
        js_url    TYPE string,
        ui5_url   TYPE string,
        abap_url  TYPE string,
        start_url TYPE string,
      END OF ty_s_app.
    TYPES ty_t_app TYPE STANDARD TABLE OF ty_s_app WITH DEFAULT KEY.

    DATA t_app TYPE ty_t_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_app.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_overview IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " base url to launch an abap2UI5 app in a new browser tab
    DATA(start) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=|.

    t_app = get_catalog( ).
    LOOP AT t_app ASSIGNING FIELD-SYMBOL(<app>).

      DATA(libpath) = replace( val = <app>-module
                               sub = `.`
                               with = `/`
                               occ = 0 ).

      " display only the bare control, without its namespace (sap.f.GridList -> GridList)
      DATA(dot) = find( val = <app>-control sub = `.` occ = -1 ).
      <app>-ctrl_name = COND #( WHEN dot >= 0 THEN substring( val = <app>-control off = dot + 1 ) ELSE <app>-control ).

      <app>-api_url   = |https://sdk.openui5.org/api/{ <app>-control }|.
      <app>-js_url    = |https://github.com/SAP/openui5/tree/master/src/{ <app>-module }| &&
                        |/test/{ libpath }/demokit/sample/{ <app>-name }|.
      <app>-ui5_url   = |https://sdk.openui5.org/resources/sap/ui/documentation/sdk/index.html| &&
                        |?sap-ui-xx-sample-id={ <app>-module }.sample.{ <app>-name }| &&
                        |&sap-ui-xx-sample-lib={ <app>-module }|.
      <app>-abap_url  = |https://github.com/abap2UI5/api/blob/main/{ <app>-path }|.
      <app>-start_url = |{ start }{ to_upper( <app>-class ) }|.

    ENDLOOP.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Shell`
            )->open( `Page`
                )->attr( n = `title`          v = `abap2UI5 - api`
                )->attr( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->attr( n = `showNavButton`  v = z2ui5_cl_api_xml=>as_bool( client->check_app_prev_stack( ) )

                )->open( `Table`
                    )->attr( n = `sticky` v = `ColumnHeaders`
                    )->attr( n = `items`  v = client->_bind( t_app )

                    )->open( `columns`
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `Module`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `Control`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `Sample`

                        )->shut(
                        )->open( `Column`
                            )->leaf( `Text`
                                )->attr( n = `text` v = `abap2UI5`

                    )->shut(
                    )->shut(

                    )->open( `items`
                        )->open( `ColumnListItem`
                            )->open( `cells`
                                )->leaf( `Text`
                                    )->attr( n = `text` v = `{MODULE}`
                                )->leaf( `Link`
                                    )->attr( n = `text`   v = `{CTRL_NAME}`
                                    )->attr( n = `href`   v = `{API_URL}`
                                    )->attr( n = `target` v = `_blank`

                                )->open( `HBox`
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `{NAME}`
                                        )->attr( n = `href`   v = `{JS_URL}`
                                        )->attr( n = `target` v = `_blank`
                                    )->leaf( `Text`
                                        )->attr( n = `text` v = ` `
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `↗`
                                        )->attr( n = `href`   v = `{UI5_URL}`
                                        )->attr( n = `target` v = `_blank`

                                )->shut(
                                )->open( `HBox`
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `{CLASS}`
                                        )->attr( n = `href`   v = `{ABAP_URL}`
                                        )->attr( n = `target` v = `_blank`
                                    )->leaf( `Text`
                                        )->attr( n = `text` v = ` `
                                    )->leaf( `Link`
                                        )->attr( n = `text`   v = `↗`
                                        )->attr( n = `href`   v = `{START_URL}`
                                        )->attr( n = `target` v = `_blank` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( module = `sap.f`       control = `sap.f.GridList`            name = `GridListBasic`             class = `z2ui5_cl_api_app_416` path = `src/04/z2ui5_cl_api_app_416.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Carousel`            name = `CarouselWithControls`      class = `z2ui5_cl_api_app_420` path = `src/01/z2ui5_cl_api_app_420.clas.abap` )
      ( module = `sap.m`       control = `sap.m.CheckBox`            name = `CheckBoxTriState`          class = `z2ui5_cl_api_app_421` path = `src/01/z2ui5_cl_api_app_421.clas.abap` )
      ( module = `sap.m`       control = `sap.m.ColorPalette`        name = `ColorPalette`              class = `z2ui5_cl_api_app_422` path = `src/01/z2ui5_cl_api_app_422.clas.abap` )
      ( module = `sap.m`       control = `sap.m.ComboBox`            name = `ComboBox`                  class = `z2ui5_cl_api_app_423` path = `src/01/z2ui5_cl_api_app_423.clas.abap` )
      ( module = `sap.m`       control = `sap.m.FacetFilter`         name = `FacetFilterLight`          class = `z2ui5_cl_api_app_401` path = `src/01/z2ui5_cl_api_app_401.clas.abap` )
      ( module = `sap.m`       control = `sap.m.FlexBox`             name = `FlexBoxNested`             class = `z2ui5_cl_api_app_404` path = `src/01/z2ui5_cl_api_app_404.clas.abap` )
      ( module = `sap.m`       control = `sap.m.GenericTile`         name = `GenericTileAsKPITile`      class = `z2ui5_cl_api_app_431` path = `src/01/z2ui5_cl_api_app_431.clas.abap` )
      ( module = `sap.m`       control = `sap.m.IconTabBar`          name = `IconTabBarStretchContent`  class = `z2ui5_cl_api_app_433` path = `src/01/z2ui5_cl_api_app_433.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Image`               name = `ImageModeBackground`       class = `z2ui5_cl_api_app_434` path = `src/01/z2ui5_cl_api_app_434.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Input`               name = `InputValueState`           class = `z2ui5_cl_api_app_439` path = `src/01/z2ui5_cl_api_app_439.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Link`                name = `LinkEmphasized`            class = `z2ui5_cl_api_app_440` path = `src/01/z2ui5_cl_api_app_440.clas.abap` )
      ( module = `sap.m`       control = `sap.m.List`                name = `ListCounter`               class = `z2ui5_cl_api_app_441` path = `src/01/z2ui5_cl_api_app_441.clas.abap` )
      ( module = `sap.m`       control = `sap.m.List`                name = `ListNoData`                class = `z2ui5_cl_api_app_445` path = `src/01/z2ui5_cl_api_app_445.clas.abap` )
      ( module = `sap.m`       control = `sap.m.MessageBox`          name = `MessageBoxInitialFocus`    class = `z2ui5_cl_api_app_447` path = `src/01/z2ui5_cl_api_app_447.clas.abap` )
      ( module = `sap.m`       control = `sap.m.MessageToast`        name = `MessageToast`              class = `z2ui5_cl_api_app_448` path = `src/01/z2ui5_cl_api_app_448.clas.abap` )
      ( module = `sap.m`       control = `sap.m.MessageView`         name = `MessageViewMessageManager` class = `z2ui5_cl_api_app_449` path = `src/01/z2ui5_cl_api_app_449.clas.abap` )
      ( module = `sap.m`       control = `sap.m.MultiComboBox`       name = `MultiComboBoxGrouping`     class = `z2ui5_cl_api_app_452` path = `src/01/z2ui5_cl_api_app_452.clas.abap` )
      ( module = `sap.m`       control = `sap.m.MultiInput`          name = `MultiInput`                class = `z2ui5_cl_api_app_454` path = `src/01/z2ui5_cl_api_app_454.clas.abap` )
      ( module = `sap.m`       control = `sap.m.ObjectHeader`        name = `ObjectHeader`              class = `z2ui5_cl_api_app_460` path = `src/01/z2ui5_cl_api_app_460.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Panel`               name = `PanelExpanded`             class = `z2ui5_cl_api_app_471` path = `src/01/z2ui5_cl_api_app_471.clas.abap` )
      ( module = `sap.m`       control = `sap.m.PDFViewer`           name = `PDFViewerPopup`            class = `z2ui5_cl_api_app_469` path = `src/01/z2ui5_cl_api_app_469.clas.abap` )
      ( module = `sap.m`       control = `sap.m.RangeSlider`         name = `RangeSlider`               class = `z2ui5_cl_api_app_472` path = `src/01/z2ui5_cl_api_app_472.clas.abap` )
      ( module = `sap.m`       control = `sap.m.ScrollContainer`     name = `ScrollContainer`           class = `z2ui5_cl_api_app_473` path = `src/01/z2ui5_cl_api_app_473.clas.abap` )
      ( module = `sap.m`       control = `sap.m.SegmentedButton`     name = `SegmentedButton`           class = `z2ui5_cl_api_app_474` path = `src/01/z2ui5_cl_api_app_474.clas.abap` )
      ( module = `sap.m`       control = `sap.m.StepInput`           name = `StepInput`                 class = `z2ui5_cl_api_app_481` path = `src/01/z2ui5_cl_api_app_481.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Text`                name = `Text`                      class = `z2ui5_cl_api_app_408` path = `src/01/z2ui5_cl_api_app_408.clas.abap` )
      ( module = `sap.m`       control = `sap.m.TextArea`            name = `TextArea`                  class = `z2ui5_cl_api_app_409` path = `src/01/z2ui5_cl_api_app_409.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Toolbar`             name = `ToolbarShrinkable`         class = `z2ui5_cl_api_app_486` path = `src/01/z2ui5_cl_api_app_486.clas.abap` )
      ( module = `sap.m`       control = `sap.m.Tree`                name = `Tree`                      class = `z2ui5_cl_api_app_487` path = `src/01/z2ui5_cl_api_app_487.clas.abap` )
      ( module = `sap.ui.core` control = `sap.ui.model.type.Integer` name = `TypeInteger`               class = `z2ui5_cl_api_app_508` path = `src/02/z2ui5_cl_api_app_508.clas.abap` ) ).

  ENDMETHOD.

ENDCLASS.
