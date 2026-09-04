" @keywords containerpadding container padding sap.ui.core containerpaddingandmargin messagestrip scrollcontainer horizontallayout image flexitemdata
" @summary By combining the margin and padding concepts you can flexibly design your application layout without having to write any custom CSS.
CLASS z2ui5_cl_smpc_app_433 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_433 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " fixed value of the original img JSONModel (/products/pic1)
    DATA pic1 TYPE string.
    DATA width_s TYPE string.
    DATA width_m TYPE string.
    DATA width_l TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    pic1 = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

    " onInit seeds /widthS /widthM /widthL from Device.system.phone (2/4/6em on a
    " phone, 5/10/15em otherwise) - expressed over the framework's device> model
    
    width_s = `{= ${device>/system/phone} ? '2em' : '5em' }`.
    
    width_m = `{= ${device>/system/phone} ? '4em' : '10em' }`.
    
    width_l = `{= ${device>/system/phone} ? '6em' : '15em' }`.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->tag( `MessageStrip`
            )->a( n = `text`  v = `A layout container by default does not add margins or paddings to the content area. By combining ` &&
                                  `the margin and padding concepts you can flexibly design your application layout without having to ` &&
                                  `add any custom CSS. This example shows a HorizontalLayout that is layouted with the standard margin ` &&
                                  `and padding classes provided by UI5.`
            )->a( n = `class` v = `sapUiTinyMargin`

        )->ele( `ScrollContainer`

            )->ele( n = `HorizontalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`

                )->ele( `Image`
                    )->a( n = `densityAware` v = `false`
                    )->a( n = `src`          v = pic1
                    )->a( n = `width`        v = width_s
                    )->a( n = `class`        v = `sapUiSmallMarginEnd`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(

                )->ele( `Image`
                    )->a( n = `densityAware` v = `false`
                    )->a( n = `src`          v = pic1
                    )->a( n = `width`        v = width_m
                    )->a( n = `class`        v = `sapUiSmallMarginEnd`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `2`

                    )->end(
                )->end(

                )->ele( `Image`
                    )->a( n = `densityAware` v = `false`
                    )->a( n = `src`          v = pic1
                    )->a( n = `width`        v = width_l

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `3` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
