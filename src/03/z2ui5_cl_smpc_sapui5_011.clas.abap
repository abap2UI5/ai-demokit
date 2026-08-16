" @keywords barcodescannerbutton shell label input
"! <p class="shorttext">sap.ndc - BarcodeScannerButton</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.ndc.BarcodeScannerButton
CLASS z2ui5_cl_smpc_sapui5_011 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_scan_input TYPE string.
    DATA mv_scan_type TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_011 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->get_event( ) = `ON_SCAN_SUCCESS`.
      client->message_box_display( `Scan finished!` ).
      DATA(lt_arg) = client->get( )-t_event_arg.
      mv_scan_input = lt_arg[ 1 ].
      mv_scan_type  = lt_arg[ 2 ].
      "implement further processing here...
      "...
      RETURN.
    ENDIF.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:ndc`    v = `sap.ndc`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `abap2UI5`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                )->a( n = `showHeader`     b = xsdbool( client->get( )-check_launchpad_active = abap_false )

                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `title`    v = `Information`
                    )->a( n = `editable` b = abap_true

                    )->ele( n = `content` ns = `form`
                        )->tag( `Label`
                            )->a( n = `text` v = `mv_scan_input`
                        )->tag( `Input`
                            )->a( n = `value` v = client->_bind( mv_scan_input )
                        )->tag( `Label`
                            )->a( n = `text` v = `mv_scan_type`
                        )->tag( `Input`
                            )->a( n = `value` v = client->_bind( mv_scan_type )
                        )->tag( `Label`
                            )->a( n = `text` v = `scanner`
                        )->tag( n = `BarcodeScannerButton` ns = `ndc`
                            )->a( n = `dialogTitle` v = `Barcode Scanner`
                            )->a( n = `scanSuccess` v = client->_event( val   = `ON_SCAN_SUCCESS`
                                                                       t_arg = VALUE #( ( `${$parameters>/text}` )
                                                                                        ( `${$parameters>/format}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
