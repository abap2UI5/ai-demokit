" @keywords dialog sap.m dialogwithinarea hbox verticallayout button flexitemdata standardlistitem
" @summary Within area of sap.ui.core.Popup determines where all popups (including dialogs) are positioned and where they can be dragged.
CLASS z2ui5_cl_smpc_app_561 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name     TYPE string,
             quantity TYPE i,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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

    " Popup.setWithinArea( withinArea ) is the SUBJECT of this sample, not a
    " detail: it confines every popup - dialogs included - to the bordered box
    " above. It reaches the frontend through the CONTROL_GLOBAL target POPUP
    " (the app-285 idiom), set once with the view rather than per press,
    " because a follow-up action runs after the popup of the same round-trip
    " has already opened. setWithinArea is @since 1.89, which this class
    " already clears - it is filed under src/02 for ariaHasPopup @1.84
    
    CLEAR temp1.
    INSERT `POPUP` INTO TABLE temp1.
    INSERT `setWithinArea` INTO TABLE temp1.
    INSERT `withinArea` INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-control_global
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD popup_dialog_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    " the three dialogs are built in the controller (new Dialog({ ... })); the
    " port builds the same one here, with the flags each press sets
    
    dialog = popup->ele( n = `FragmentDefinition` ns = `core`
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
        popup_dialog_display( title = `Available Products` begin_ok = abap_true ).

      WHEN `DIALOG_RESIZABLE`.
        popup_dialog_display( title = `Resizable Available Products` sized = abap_true resizable = abap_true ).

      WHEN `DIALOG_DRAGGABLE`.
        popup_dialog_display( title = `Draggable Available Products` sized = abap_true draggable = abap_true ).

      WHEN `DIALOG_CLOSE`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection - the dialogs bind the whole list
    DATA temp3 TYPE z2ui5_cl_smpc_app_561=>ty_t_product.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-quantity = 30.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Senior`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-I`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-II`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Screen E-III`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Basic`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Future`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XL`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Professional Eco`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Basic`.
    temp4-quantity = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Laser Allround`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Color`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Mobile`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Print`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Multi Color`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Mouse`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Speed Mouse`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Track Mouse`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergonomic Keyboard`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Internet Keyboard`.
    temp4-quantity = 35.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Media Keyboard`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mousepad`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ergo Mousepad`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Designer Mousepad`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Universal card reader`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Proctra X`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gladiator MX`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Hurricane GX/LN`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Photo Scan`.
    temp4-quantity = 8.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Scan`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Jet Scan Professional`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copymaster`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Surround Sound`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Blaster Extreme`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Sound Booster`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound 5.1`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Lovely Sound Stereo`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Office`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Design`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Network`.
    temp4-quantity = 28.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Multimedia`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Games`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Internet Antivirus`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Firewall`.
    temp4-quantity = 19.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smart Money`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Lock`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Lock`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Web cam reality`.
    temp4-quantity = 27.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Screen clean`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Fabric bag professional`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `USB Stick`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Travel Adapter`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat XXL`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Pocket Mouse`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `PC Power Station`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Laptop 1516`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Astro Phone 6`.
    temp4-quantity = 28.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Benda Laptop 1408`.
    temp4-quantity = 27.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Bending Screen 21HD`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Broad Screen 22HD`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cerdik Phone 7`.
    temp4-quantity = 19.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-quantity = 17.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Cepat Tablet 8`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Basic`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Professional`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Server Power Pro`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Basic`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Family PC Pro`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Gaming Monster Pro`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `10" Portable DVD player`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-quantity = 26.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-quantity = 25.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-1`.
    temp4-quantity = 32.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-2`.
    temp4-quantity = 18.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Beam Breaker B-3`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Play Movie`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Record Movie`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo MusicStick`.
    temp4-quantity = 15.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelo Jog-Mate`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 40`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Power Pro Player 80`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD32`.
    temp4-quantity = 16.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD37`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flat Watch HD41`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Copperberry`.
    temp4-quantity = 5.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Silverberry`.
    temp4-quantity = 9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Goldberry`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Platinberry`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-quantity = 11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Leather Case`.
    temp4-quantity = 12.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Alpha`.
    temp4-quantity = 13.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Mini Tablet`.
    temp4-quantity = 10.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Camcorder View`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Tablet Pouch`.
    temp4-quantity = 34.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-quantity = 23.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Smartphone Beta`.
    temp4-quantity = 21.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Maxi Tablet`.
    temp4-quantity = 20.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Flyer`.
    temp4-quantity = 33.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
