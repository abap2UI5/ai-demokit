"! <p class="shorttext">sap.ndc - BarcodeScannerButton</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS §3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.ndc.BarcodeScannerButton
CLASS z2ui5_cl_dmo_sapui5_011 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_scan_input TYPE string.
    DATA mv_scan_type TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_dmo_sapui5_011 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.

      WHEN `ON_SCAN_SUCCESS`.
        client->message_box_display( `Scan finished!`).
        DATA(lt_arg) = client->get( )-t_event_arg.
        mv_scan_input = lt_arg[ 1 ].
        mv_scan_type  = lt_arg[ 2 ].
        "implement further processing here...
        "...
        client->view_model_update( ).
        RETURN.
    ENDCASE.

    client->view_display( z2ui5_cl_xml_view=>factory( )->shell(
          )->page(
                 showheader      = xsdbool( abap_false = client->get( )-check_launchpad_active )
                  title          = `abap2UI5`
                  navbuttonpress = client->_event_nav_app_leave( )
                  shownavbutton  = client->check_app_prev_stack( )
              )->simple_form( title    = `Information`
                              editable = abap_true
                  )->content( `form`
                      )->label( `mv_scan_input`
                      )->input( client->_bind( mv_scan_input )
                      )->label( `mv_scan_type`
                      )->input( client->_bind( mv_scan_type )
                      )->label( `scanner`
                      )->barcode_scanner_button(
                        scansuccess = client->_event( val = `ON_SCAN_SUCCESS` t_arg = VALUE #( ( `${$parameters>/text}` ) ( `${$parameters>/format}` ) ) )
                        dialogtitle = `Barcode Scanner`
           )->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
