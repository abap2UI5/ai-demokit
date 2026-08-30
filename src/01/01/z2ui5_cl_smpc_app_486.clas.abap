" @keywords objectheader object header sap.m objectheadertitleactive objectattribute responsivepopover text
" @summary The Object Header's title can be active to trigger further actions like showing additional information in a Popover.
CLASS z2ui5_cl_smpc_app_486 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the record the original binds with binding="{/ProductCollection/0}"
    DATA name          TYPE string.
    DATA price         TYPE p LENGTH 8 DECIMALS 2.
    DATA currencycode  TYPE string.
    DATA weightmeasure TYPE string.
    DATA weightunit    TYPE string.
    DATA width         TYPE string.
    DATA depth         TYPE string.
    DATA height        TYPE string.
    DATA dimunit       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_486 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `title`       v = client->_bind( name )
            )->a( n = `titleActive` v = `true`
            " handleTitlePress loads Popover.fragment.xml and opens it by the title's
            " domRef - the same popover is declared in dependents and opened anchored
            " to the pressed control, roundtrip-free
            )->a( n = `titlePress`  v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                  t_arg = VALUE #( ( `myPopover` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )
            )->a( n = `number`      v = |\{ parts:[\{path:'{ client->_bind_path( price ) }'\},| &&
                                         |\{path:'{ client->_bind_path( currencycode ) }'\}],| &&
                                         | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`  v = client->_bind( currencycode )
            )->a( n = `class`       v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( weightmeasure ) } { client->_bind( weightunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( width ) } x { client->_bind( depth ) } x { client->_bind( height ) } { client->_bind( dimunit ) }|

            )->ele( `dependents`
                )->ele( `ResponsivePopover`
                    )->a( n = `id`    v = `myPopover`
                    )->a( n = `title` v = `About`
                    )->a( n = `class` v = `sapUiContentPadding`

                    )->tag( `Text`
                        )->a( n = `text` v = `... more content goes here` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/0 of ui5/mock/products.json, the fields the view binds
    name          = `Notebook Basic 15`.
    price         = '956.00'.
    currencycode  = `EUR`.
    weightmeasure = `4.2`.
    weightunit    = `KG`.
    width         = `30`.
    depth         = `18`.
    height        = `3`.
    dimunit       = `cm`.

  ENDMETHOD.

ENDCLASS.
