" @keywords headercontainer sap.m headercontainerlazyloading objectheader numericcontent objectmarker scroll lazy loading
CLASS z2ui5_cl_smpc_app_605 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_content,
             value  TYPE string,
             color  TYPE string,
             growth TYPE string,
           END OF ty_s_content.
    TYPES ty_t_content TYPE STANDARD TABLE OF ty_s_content WITH EMPTY KEY.

    " the ObjectHeader's binding="{/ProductCollection/}" folded onto root fields
    DATA description   TYPE string.
    DATA name          TYPE string.
    DATA price         TYPE string.
    DATA currencycode  TYPE string.
    DATA suppliername  TYPE string.

    DATA t_content TYPE ty_t_content.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS content_append.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_605 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `ObjectHeader`
            )->a( n = `id`               v = `oh1`
            )->a( n = `responsive`       v = `true`
            " binding="{/ProductCollection/}" - one record, folded onto the root
            )->a( n = `intro`            v = client->_bind( description )
            )->a( n = `title`            v = client->_bind( name )
            )->a( n = `number`           v = client->_bind( price )
            )->a( n = `numberUnit`       v = client->_bind( currencycode )
            )->a( n = `numberState`      v = `Success`
            )->a( n = `backgroundDesign` v = `Translucent`

            )->ele( `attributes`
                )->tag( `ObjectAttribute`
                    )->a( n = `title` v = `Manufacturer`
                    )->a( n = `text`  v = client->_bind( suppliername )
            )->end(

            )->ele( `statuses`
                )->tag( `ObjectStatus`
                    )->a( n = `title` v = `Approval`
                    )->a( n = `text`  v = `Pending`
                    )->a( n = `state` v = `Warning`
            )->end(

            )->ele( `markers`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Flagged`
                )->tag( `ObjectMarker`
                    )->a( n = `type` v = `Favorite`
            )->end(

            )->ele( `headerContainer`
                )->ele( `HeaderContainer`
                    )->a( n = `id`         v = `headerContainer`
                    )->a( n = `scrollStep` v = `200`
                    " onScroll pushes three more tiles onto the model - the lazy
                    " loading this sample is about; the backend appends instead
                    )->a( n = `scroll`     v = client->_event( `SCROLL` )
                    )->a( n = `content`    v = client->_bind( t_content )

                    )->ele( `content`
                        )->tag( `NumericContent`
                            )->a( n = `scale`      v = `M`
                            )->a( n = `value`      v = `{VALUE}`
                            )->a( n = `valueColor` v = `{COLOR}`
                            )->a( n = `indicator`  v = `{GROWTH}`
                            )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = VALUE #( ( `MESSAGE_BOX` ) ( `alert` ) ( `Link was clicked!` ) ) )
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SCROLL`.
      content_append( ).
    ENDIF.

  ENDMETHOD.


  METHOD content_append.

    " onScroll appends three tiles whose value, colour and growth are RANDOM.
    " A backend cannot draw the browser's numbers, so the three that come next
    " are taken from the mock's own list, cycling (see sidecar)
    DATA(seed) = lines( t_content ).
    DO 3 TIMES.
      DATA(index) = ( seed + sy-index - 1 ) MOD 11 + 1.
      INSERT t_content[ index ] INTO TABLE t_content.
    ENDDO.

  ENDMETHOD.


  METHOD model_init.

    " data.json /ProductCollection - the single record the ObjectHeader binds
    description  = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    name         = `Notebook Basic 15`.
    price        = `956`.
    currencycode = `EUR`.
    suppliername = `Very Best Screens`.

    " data.json /ContentData - the eleven tiles the HeaderContainer starts with
    t_content = VALUE #(
      ( value = `1.75` color = `Good` growth = `Up` )
      ( value = `0.52` color = `Neutral` growth = `Up` )
      ( value = `1.62` color = `Good` growth = `Down` )
      ( value = `0.65` color = `Good` growth = `Up` )
      ( value = `2.84` color = `Error` growth = `Down` )
      ( value = `0.73` color = `Good` growth = `Up` )
      ( value = `0.32` color = `Good` growth = `Up` )
      ( value = `0.97` color = `Error` growth = `Down` )
      ( value = `2.25` color = `Neutral` growth = `Down` )
      ( value = `3.27` color = `Error` growth = `Up` )
      ( value = `1.15` color = `Neutral` growth = `Up` )
    ).

  ENDMETHOD.

ENDCLASS.
