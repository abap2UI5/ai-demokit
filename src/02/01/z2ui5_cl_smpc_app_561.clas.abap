" @keywords dialog sap.m dialogwithinarea hbox button flexitemdata standardlistitem
" @summary Within area of sap.ui.core.Popup determines where all popups (including dialogs) are positioned and where they can be dragged.
CLASS z2ui5_cl_smpc_app_561 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name     TYPE string,
             quantity TYPE i,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_dialog_display
      IMPORTING title     TYPE string
                resizable TYPE abap_bool DEFAULT abap_false
                draggable TYPE abap_bool DEFAULT abap_false
                sized     TYPE abap_bool DEFAULT abap_false
                begin_ok  TYPE abap_bool DEFAULT abap_false.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_561 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `HBox`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->a( n = `width` v = `100%`

                )->tag( `Button`
                    )->a( n = `text`         v = `Dialog`
                    )->a( n = `width`        v = `230px`
                    )->a( n = `press`        v = client->_event( `DIALOG_DEFAULT` )
                    )->a( n = `class`        v = `sapUiSmallMarginBottom`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                )->tag( `Button`
                    )->a( n = `text`         v = `Dialog (Resizable)`
                    )->a( n = `width`        v = `230px`
                    )->a( n = `press`        v = client->_event( `DIALOG_RESIZABLE` )
                    )->a( n = `class`        v = `sapUiSmallMarginBottom`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                )->tag( `Button`
                    )->a( n = `text`         v = `Dialog (Draggable)`
                    )->a( n = `width`        v = `230px`
                    )->a( n = `press`        v = client->_event( `DIALOG_DRAGGABLE` )
                    )->a( n = `class`        v = `sapUiSmallMarginBottom`
                    )->a( n = `ariaHasPopup` v = `Dialog`

            )->end(

            " Popup.setWithinArea( withinArea ) confines every popup to this box;
            " that call has no declarative counterpart (see sidecar), so the box
            " is kept and the confinement is not
            )->ele( `HBox`
                )->a( n = `id`               v = `withinArea`
                )->a( n = `backgroundDesign` v = `Solid`
                )->a( n = `height`           v = `30rem`

                )->ele( `layoutData`
                    )->tag( `FlexItemData`
                        )->a( n = `growFactor`       v = `1`
                        )->a( n = `backgroundDesign` v = `Solid`
                        )->a( n = `styleClass`       v = `sapUiMediumMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the three dialogs are built in the controller (new Dialog({ ... })); the
    " port builds the same one here, with the flags each press sets
    DATA(dialog) = popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Dialog`
            )->a( n = `title` v = title ).

    IF sized = abap_true.
      dialog->a( n = `contentWidth`  v = `550px`
          )->a( n = `contentHeight` v = `300px` ).
    ENDIF.
    IF resizable = abap_true.
      dialog->a( n = `resizable` v = `true` ).
    ENDIF.
    IF draggable = abap_true.
      dialog->a( n = `draggable` v = `true` ).
    ENDIF.

    IF begin_ok = abap_true.
      dialog->ele( `beginButton`
          )->tag( `Button`
              )->a( n = `type`  v = `Emphasized`
              )->a( n = `text`  v = `OK`
              )->a( n = `press` v = client->_event( `DIALOG_CLOSE` ) ).
    ENDIF.

    dialog->ele( `endButton`
        )->tag( `Button`
            )->a( n = `text`  v = `Close`
            )->a( n = `press` v = client->_event( `DIALOG_CLOSE` ) ).

    dialog->ele( `List`
        )->a( n = `items` v = client->_bind( t_products )
        )->tag( `StandardListItem`
            )->a( n = `title`   v = `{NAME}`
            )->a( n = `counter` v = `{QUANTITY}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `DIALOG_DEFAULT`.
        popup_dialog_display( title    = `Available Products`
                              begin_ok = abap_true ).

      WHEN `DIALOG_RESIZABLE`.
        popup_dialog_display( title     = `Resizable Available Products`
                              sized     = abap_true
                              resizable = abap_true ).

      WHEN `DIALOG_DRAGGABLE`.
        popup_dialog_display( title     = `Draggable Available Products`
                              sized     = abap_true
                              draggable = abap_true ).

      WHEN `DIALOG_CLOSE`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection - the dialogs bind the whole list
    t_products = VALUE #(
      ( name = `Notebook Basic 15` quantity = 10 )
      ( name = `Notebook Basic 17` quantity = 20 )
      ( name = `Notebook Basic 18` quantity = 10 )
      ( name = `Notebook Basic 19` quantity = 15 )
      ( name = `ITelO Vault` quantity = 15 )
      ( name = `Notebook Professional 15` quantity = 16 )
      ( name = `Notebook Professional 17` quantity = 17 )
      ( name = `ITelO Vault Net` quantity = 14 )
      ( name = `ITelO Vault SAT` quantity = 50 )
      ( name = `Comfort Easy` quantity = 30 )
      ( name = `Comfort Senior` quantity = 24 )
      ( name = `Ergo Screen E-I` quantity = 14 )
      ( name = `Ergo Screen E-II` quantity = 24 )
      ( name = `Ergo Screen E-III` quantity = 50 )
      ( name = `Flat Basic` quantity = 23 )
      ( name = `Flat Future` quantity = 22 )
      ( name = `Flat XL` quantity = 23 )
      ( name = `Laser Professional Eco` quantity = 21 )
      ( name = `Laser Basic` quantity = 8 )
      ( name = `Laser Allround` quantity = 9 )
      ( name = `Ultra Jet Super Color` quantity = 17 )
      ( name = `Ultra Jet Mobile` quantity = 18 )
      ( name = `Ultra Jet Super Highspeed` quantity = 25 )
      ( name = `Multi Print` quantity = 16 )
      ( name = `Multi Color` quantity = 5 )
      ( name = `Cordless Mouse` quantity = 25 )
      ( name = `Speed Mouse` quantity = 12 )
      ( name = `Track Mouse` quantity = 12 )
      ( name = `Ergonomic Keyboard` quantity = 50 )
      ( name = `Internet Keyboard` quantity = 35 )
      ( name = `Media Keyboard` quantity = 26 )
      ( name = `Mousepad` quantity = 12 )
      ( name = `Ergo Mousepad` quantity = 16 )
      ( name = `Designer Mousepad` quantity = 26 )
      ( name = `Universal card reader` quantity = 22 )
      ( name = `Proctra X` quantity = 15 )
      ( name = `Gladiator MX` quantity = 16 )
      ( name = `Hurricane GX` quantity = 13 )
      ( name = `Hurricane GX/LN` quantity = 5 )
      ( name = `Photo Scan` quantity = 8 )
      ( name = `Power Scan` quantity = 11 )
      ( name = `Jet Scan Professional` quantity = 13 )
      ( name = `Jet Scan Professional` quantity = 10 )
      ( name = `Copymaster` quantity = 10 )
      ( name = `Surround Sound` quantity = 20 )
      ( name = `Blaster Extreme` quantity = 15 )
      ( name = `Sound Booster` quantity = 50 )
      ( name = `Lovely Sound 5.1 Wireless` quantity = 12 )
      ( name = `Lovely Sound 5.1` quantity = 18 )
      ( name = `Lovely Sound Stereo` quantity = 21 )
      ( name = `Smart Office` quantity = 25 )
      ( name = `Smart Design` quantity = 26 )
      ( name = `Smart Network` quantity = 28 )
      ( name = `Smart Multimedia` quantity = 9 )
      ( name = `Smart Games` quantity = 13 )
      ( name = `Smart Internet Antivirus` quantity = 17 )
      ( name = `Smart Firewall` quantity = 19 )
      ( name = `Smart Money` quantity = 18 )
      ( name = `PC Lock` quantity = 14 )
      ( name = `Notebook Lock` quantity = 20 )
      ( name = `Web cam reality` quantity = 27 )
      ( name = `Screen clean` quantity = 17 )
      ( name = `Fabric bag professional` quantity = 14 )
      ( name = `Wireless DSL Router` quantity = 16 )
      ( name = `Wireless DSL Router / Repeater` quantity = 12 )
      ( name = `Wireless DSL Router / Repeater and Print Server` quantity = 12 )
      ( name = `USB Stick` quantity = 14 )
      ( name = `Travel Adapter` quantity = 10 )
      ( name = `Cordless Bluetooth Keyboard, english international` quantity = 13 )
      ( name = `Flat XXL` quantity = 10 )
      ( name = `Pocket Mouse` quantity = 20 )
      ( name = `PC Power Station` quantity = 22 )
      ( name = `Astro Laptop 1516` quantity = 23 )
      ( name = `Astro Phone 6` quantity = 28 )
      ( name = `Benda Laptop 1408` quantity = 27 )
      ( name = `Bending Screen 21HD` quantity = 23 )
      ( name = `Broad Screen 22HD` quantity = 5 )
      ( name = `Cerdik Phone 7` quantity = 19 )
      ( name = `Cepat Tablet 10.5` quantity = 17 )
      ( name = `Cepat Tablet 8` quantity = 24 )
      ( name = `Server Basic` quantity = 24 )
      ( name = `Server Professional` quantity = 26 )
      ( name = `Server Power Pro` quantity = 34 )
      ( name = `Family PC Basic` quantity = 10 )
      ( name = `Family PC Pro` quantity = 20 )
      ( name = `Gaming Monster` quantity = 24 )
      ( name = `Gaming Monster Pro` quantity = 25 )
      ( name = `7" Widescreen Portable DVD Player w MP3` quantity = 20 )
      ( name = `10" Portable DVD player` quantity = 21 )
      ( name = `Portable DVD Player with 9" LCD Monitor` quantity = 50 )
      ( name = `CD/DVD case: 264 sleeves` quantity = 26 )
      ( name = `Audio/Video Cable Kit - 4m` quantity = 16 )
      ( name = `Removable CD/DVD Laser Labels` quantity = 25 )
      ( name = `Beam Breaker B-1` quantity = 32 )
      ( name = `Beam Breaker B-2` quantity = 18 )
      ( name = `Beam Breaker B-3` quantity = 16 )
      ( name = `Play Movie` quantity = 15 )
      ( name = `Record Movie` quantity = 24 )
      ( name = `ITelo MusicStick` quantity = 15 )
      ( name = `ITelo Jog-Mate` quantity = 24 )
      ( name = `Power Pro Player 40` quantity = 23 )
      ( name = `Power Pro Player 80` quantity = 13 )
      ( name = `Flat Watch HD32` quantity = 16 )
      ( name = `Flat Watch HD37` quantity = 14 )
      ( name = `Flat Watch HD41` quantity = 13 )
      ( name = `Copperberry` quantity = 5 )
      ( name = `Silverberry` quantity = 9 )
      ( name = `Goldberry` quantity = 11 )
      ( name = `Platinberry` quantity = 12 )
      ( name = `ITelO FlexTop I4000` quantity = 11 )
      ( name = `ITelO FlexTop I6300c` quantity = 20 )
      ( name = `ITelO FlexTop I9100` quantity = 20 )
      ( name = `ITelO FlexTop I9800` quantity = 22 )
      ( name = `Smartphone Leather Case` quantity = 12 )
      ( name = `Smartphone Alpha` quantity = 13 )
      ( name = `Mini Tablet` quantity = 10 )
      ( name = `Camcorder View` quantity = 50 )
      ( name = `Tablet Pouch` quantity = 34 )
      ( name = `Tablet Pouch` quantity = 34 )
      ( name = `e-Book Reader ReadMe` quantity = 23 )
      ( name = `Smartphone Beta` quantity = 21 )
      ( name = `Maxi Tablet` quantity = 20 )
      ( name = `Flyer` quantity = 33 )
    ).

  ENDMETHOD.

ENDCLASS.
