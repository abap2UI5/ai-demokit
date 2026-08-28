" @keywords objectheader object header sap.m objectheadercircleimage objectattribute
" @summary An Object Header can set shape of the image by using 'imageShape' property. The shapes could be Square (by default) and Circle. Note: This example shows the image inside ObjectHeader with the responsive property set to true.
CLASS z2ui5_cl_smpc_app_400 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_400 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            " asset path kept verbatim, only host-absolutized to the OpenUI5 host
            )->a( n = `icon`             v = `https://sdk.openui5.org/test-resources/sap/m/images/Woman_04.png`
            )->a( n = `iconDensityAware` v = `false`
            )->a( n = `iconAlt`          v = `Denise Smith`
            )->a( n = `imageShape`       v = `Circle`
            )->a( n = `responsive`       v = `true`
            )->a( n = `title`            v = `Denise Smith`
            )->a( n = `intro`            v = `Senior Developer`
            )->a( n = `class`            v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `title`  v = `Email address`
                )->a( n = `text`   v = `DeniseSmith@sap.com`
                )->a( n = `active` v = `true`
            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Office Phone`
                )->a( n = `text`  v = `+33 6 453 564`
            )->tag( `ObjectAttribute`
                )->a( n = `title` v = `Functional Area`
                )->a( n = `text`  v = `Development` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
