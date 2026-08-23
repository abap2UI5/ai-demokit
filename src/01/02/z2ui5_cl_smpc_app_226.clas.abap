" @keywords grid sap.ui.layout gridxl verticallayout title text image griddata
" @summary The major layout features of the Grid control are shown in this example. Features like indentation, making content visible/invisible based on the screen size, moving content forward and backwards are demonstrated.
CLASS z2ui5_cl_smpc_app_226 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_information,
        introtext1     TYPE string,
        introtext2     TYPE string,
        introtext3     TYPE string,
        description1   TYPE string,
        description2   TYPE string,
        productpicurl  TYPE string,
        productpicurl2 TYPE string,
      END OF ty_s_information.
    DATA informationcollection TYPE STANDARD TABLE OF ty_s_information WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_226 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( n = `Grid` ns = `l`
            )->a( n = `binding`     v = |\{{ client->_bind( val = informationcollection path = abap_true ) }\}|
            )->a( n = `hSpacing`    v = `0`
            )->a( n = `defaultSpan` v = `XL6 L6 M6 S12`
            )->a( n = `class`       v = `sapUiSmallMargin`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiTinyMarginEnd`

                )->tag( `Title`
                    )->a( n = `level`      v = `H1`
                    )->a( n = `titleStyle` v = `H1`
                    )->a( n = `text`       v = `Demo App`
                    )->a( n = `class`      v = `sapUiMediumMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`  v = `{0/INTROTEXT1}`
                    )->a( n = `class` v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`  v = `{0/INTROTEXT2}`
                    )->a( n = `class` v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text`  v = `{0/INTROTEXT3}`
                    )->a( n = `class` v = `sapUiTinyMarginBottom`

            )->end(
            " src host-prefixed to sdk.openui5.org per the asset-URL rule (original: relative resources/ path)
            )->ele( `Image`
                )->a( n = `src`          v = `https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/demoAppsTeaser.png`
                )->a( n = `densityAware` v = `false`
                )->a( n = `width`        v = `100%`

                )->ele( `layoutData`
                    )->tag( n = `GridData` ns = `l`
                        )->a( n = `visibleS` v = `false`

                )->end(
            )->end(
        )->end(

        )->ele( n = `Grid` ns = `l`
            )->a( n = `hSpacing`      v = `0`
            )->a( n = `vSpacing`      v = `0`
            )->a( n = `binding`       v = |\{{ client->_bind( val = informationcollection path = abap_true ) }\}|
            )->a( n = `class`         v = `sapUiSmallMargin`
            )->a( n = `defaultSpan`   v = `XL5 L5 M5 S12`
            )->a( n = `defaultIndent` v = `XL1 L1 M1`

            )->ele( `Title`
                )->a( n = `level`      v = `H2`
                )->a( n = `titleStyle` v = `H2`
                )->a( n = `text`       v = `Products`

                )->ele( `layoutData`
                    )->tag( n = `GridData` ns = `l`
                        )->a( n = `span`   v = `XL12 L12 M12 S12`
                        )->a( n = `indent` v = `XL0 L0 M0`

                )->end(
            )->end(
            )->ele( `Image`
                )->a( n = `src`          v = `{3/PRODUCTPICURL2}`
                )->a( n = `densityAware` v = `false`
                )->a( n = `width`        v = `100%`

                )->ele( `layoutData`
                    )->tag( n = `GridData` ns = `l`
                        )->a( n = `moveForward` v = `M6`

                )->end(
            )->end(
            )->ele( `Image`
                )->a( n = `src`          v = `{1/PRODUCTPICURL}`
                )->a( n = `densityAware` v = `false`
                )->a( n = `width`        v = `100%`

                )->ele( `layoutData`
                    )->tag( n = `GridData` ns = `l`
                        )->a( n = `moveBackwards` v = `M6`

                )->end(
            )->end(
        )->end(

        )->ele( n = `Grid` ns = `l`
            )->a( n = `binding`     v = |\{{ client->_bind( val = informationcollection path = abap_true ) }\}|
            )->a( n = `hSpacing`    v = `0`
            )->a( n = `defaultSpan` v = `XL3 L5 M5 S12`
            )->a( n = `class`       v = `sapUiSmallMargin`

            )->ele( `Image`
                )->a( n = `src`          v = `{2/PRODUCTPICURL}`
                )->a( n = `densityAware` v = `false`
                )->a( n = `width`        v = `100%`

                )->ele( `layoutData`
                    )->tag( n = `GridData` ns = `l`
                        )->a( n = `indent` v = `XL1 L1 M1`

                )->end(
            )->end(
            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiTinyMargin`

                )->tag( `Text`
                    )->a( n = `text`  v = `{0/DESCRIPTION1}`
                    )->a( n = `class` v = `sapUiTinyMarginBottom`
                )->tag( `Text`
                    )->a( n = `text` v = `{0/DESCRIPTION2}`

            )->end(
            )->ele( `Image`
                )->a( n = `src`          v = `{1/PRODUCTPICURL2}`
                )->a( n = `densityAware` v = `false`
                )->a( n = `width`        v = `100%`

                )->ele( `layoutData`
                    )->tag( n = `GridData` ns = `l`
                        )->a( n = `linebreakXL` v = `false`
                        )->a( n = `linebreakL`  v = `true`
                        )->a( n = `visibleM`    v = `false`
                        )->a( n = `visibleS`    v = `true`
                        )->a( n = `indent`      v = `L1`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " InformationCollection from ui5/sap.ui.layout/GridXL/information.json, verbatim (all 5 rows).
    " Only row 0 carries the intro/description texts; every row carries the two product image URLs,
    " host-prefixed to sdk.openui5.org per the project asset-URL rule.
    informationcollection = VALUE #(
      ( introtext1   = `This Grid Layout sample application demonstrates the major features and capabilites of the Grid Layout. There are 3 Grid Layouts used in this application.`
        introtext2   = `In the first Grid Layout, when the screen size is reduced to 'Small' or 'Mobile', the image on the right is made invisible by using the property 'visibleOnSmall=false' of the GridData control.`
        introtext3   = `In the second Grid Layout, that is in the Products section, when the screen size is reduced to 'Medium' or 'Tablet', the images are swapped by using properties 'moveForward' and 'moveBackwards' of the` &&
                       ` GridData control. There is also indentation applied the images when the screen sizes are 'Extra-large, Large and Medium'.`
        description1 = `In this Grid Layout, when the screen size is 'Extra-large' or 'Large Desktop' then there are 2 Images and 1 Text control rendered in 1 row. But when the screen is reduced to 'Large' or 'Smaller` &&
                       ` Desktop', there is a line break for the image on the right and it is rendered in a new row. This is achieved by using the properties 'linebreakXL=false' and 'linebreakL=true' of the GridData control.`
        description2 = `When the screen is further reduced to 'Medium' or 'Tablet', the image rendered in the new row is made invisible by using the property 'visibleOnMedium=false' of the GridData control and this image is` &&
                       ` visible again when the screen size if further reduced to 'Small' or 'Mobile'.`
        productpicurl  = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`
        productpicurl2 = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` )
      ( productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` productpicurl2 = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg` )
      ( productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` productpicurl2 = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` )
      ( productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` productpicurl2 = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` )
      ( productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` productpicurl2 = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` ) ).

  ENDMETHOD.

ENDCLASS.
