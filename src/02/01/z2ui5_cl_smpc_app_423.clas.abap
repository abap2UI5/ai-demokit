" @keywords segmentedbutton segmented button sap.m segmentedbuttoncontentmodes segmentedbuttonitem
" @summary Segmented Button different Content Modes
CLASS z2ui5_cl_smpc_app_423 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_423 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            " contentMode ContentFit - sap.m.SegmentedButton.contentMode is @since 1.142 (POST_171)
            )->ele( `SegmentedButton`
                )->a( n = `contentMode` v = `ContentFit`

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `This is a very large text for demonstration purposes`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Medium text`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Small`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://lab`

                )->end(
            )->end(

            " the same four items with contentMode EqualSized - all buttons share one width
            )->ele( `SegmentedButton`
                )->a( n = `contentMode` v = `EqualSized`

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `This is a very large text for demonstration purposes`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Medium text`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `text` v = `Small`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://lab` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
