CLASS z2ui5_cl_dmo_app_269 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_entry,
             author       TYPE string,
             authorpicurl TYPE string,
             type         TYPE string,
             date         TYPE string,
             text         TYPE string,
           END OF ty_s_entry.

    DATA t_entrycollection  TYPE STANDARD TABLE OF ty_s_entry WITH EMPTY KEY.
    DATA toggle_enabled     TYPE abap_bool.
    DATA show_side_btn      TYPE abap_bool.
    DATA show_side_content  TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_269 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The controller's media model (new JSONModel(Device.system)) is the shared
    " device> model here, so {media>/phone} becomes {device>/system/phone}.
    " toggle()/setShowSideContent() are public control methods driven through
    " control_by_id; the breakpointChanged round-trip keeps the two button
    " flags in sync exactly like updateToggleButtonState /
    " updateShowSideContentButtonVisibility.
    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`

            )->open( `Page`
                )->a( n = `id`            v = `sideContentContainer`
                )->a( n = `showHeader`    v = `false`
                )->a( n = `showNavButton` v = `false`

                )->open( n = `DynamicSideContent` ns = `l`
                    )->a( n = `id`                  v = `DynamicSideContent`
                    )->a( n = `class`               v = `sapUiDSCExplored sapUiContentPadding`
                    )->a( n = `containerQuery`      v = `true`
                    )->a( n = `showSideContent`     v = client->_bind( show_side_content )
                    )->a( n = `sideContentFallDown` v = `BelowM`
                    )->a( n = `breakpointChanged`   v = client->_event( val   = `BREAKPOINT_CHANGED`
                                                                        t_arg = VALUE #( ( `${$parameters>/currentBreakpoint}` ) ) )

                    )->open( `VBox`
                        )->leaf( `Title`
                            )->a( n = `level` v = `H1`
                            )->a( n = `text`  v = `Product`
                        )->leaf( `Image`
                            )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                            )->a( n = `densityAware` v = `false`
                            )->a( n = `width`        v = `10em`
                        )->leaf( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor `
                                              && `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud `
                                              && `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure `
                                              && `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. `
                                              && `Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt `
                                              && `mollit anim id est laborum.`

                    )->shut(

                    )->open( n = `sideContent` ns = `l`
                        )->open( `Toolbar`
                            )->leaf( `Title`
                                )->a( n = `text` v = `Comments`
                            )->leaf( `ToolbarSpacer`
                            )->leaf( `Button`
                                )->a( n = `text`    v = `Close`
                                )->a( n = `type`    v = `Transparent`
                                )->a( n = `visible` v = |\{= !$\{device>/system/phone\}\}|
                                )->a( n = `press`   v = client->_event( `SIDE_CONTENT_HIDE` )

                        )->shut(

                        )->open( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->open( `List`
                                )->a( n = `items` v = client->_bind( t_entrycollection )

                                )->leaf( `FeedListItem`
                                    )->a( n = `sender`    v = `{AUTHOR}`
                                    )->a( n = `icon`      v = `{AUTHORPICURL}`
                                    )->a( n = `info`      v = `{TYPE}`
                                    )->a( n = `timestamp` v = `{DATE}`
                                    )->a( n = `text`      v = `{TEXT}`

                            )->shut(

                            )->leaf( `FeedInput`
                                )->a( n = `showIcon` v = `true`
                                )->a( n = `icon`     v = `http://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `footer`
                )->open( `Toolbar`
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Toggle`
                        )->a( n = `type`    v = `Accept`
                        )->a( n = `id`      v = `toggleButton`
                        )->a( n = `enabled` v = client->_bind( toggle_enabled )
                        )->a( n = `press`   v = client->_event_client( val   = client->cs_event-control_by_id
                                                                       t_arg = VALUE #( ( `DynamicSideContent` ) ( `toggle` ) ) )
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Open Side Content`
                        )->a( n = `id`      v = `showSideContentButton`
                        )->a( n = `visible` v = client->_bind( show_side_btn )
                        )->a( n = `press`   v = client->_event( `SIDE_CONTENT_SHOW` )
                    )->leaf( `Slider`
                        )->a( n = `id`      v = `DSCWidthSlider`
                        )->a( n = `value`   v = `100`
                        )->a( n = `visible` v = |\{= !$\{device>/system/phone\}\}|
                        " handleSliderChange: the container is a sap.m.Page, which
                        " has no width property - the `css` control method writes
                        " the percentage onto its DOM node like the original jQuery
                        )->a( n = `liveChange` v = client->_event_client(
                                  val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `sideContentContainer` )
                                                   ( `css` )
                                                   ( `width` )
                                                   ( `${$parameters>/value} + '%'` ) ) )
                    )->leaf( `Text`
                        )->a( n = `id`      v = `DSCWidthHintText`
                        )->a( n = `text`    v = `Best view in full screen`
                        )->a( n = `visible` v = |\{= !$\{device>/system/phone\}\}|

                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `BREAKPOINT_CHANGED`.
        " updateToggleButtonState: the Toggle button is enabled on S only.
        " updateShowSideContentButtonVisibility: the Open Side Content button
        " shows unless the breakpoint is S (the original additionally hides it
        " while the side content is visible - see the sidecar)
        DATA(lv_breakpoint) = client->get_event_arg( ).
        toggle_enabled = xsdbool( lv_breakpoint = `S` ).
        show_side_btn  = xsdbool( lv_breakpoint <> `S` ).

      WHEN `SIDE_CONTENT_HIDE`.
        " handleSideContentHide: setShowSideContent(false) + re-evaluate the
        " Open Side Content button. showSideContent is a bindable property, so
        " the flag is bound two-way and only flipped here
        show_side_content = abap_false.
        show_side_btn     = abap_true.

      WHEN `SIDE_CONTENT_SHOW`.
        " handleSideContentShow: setShowSideContent(true); the button hides
        " itself again because the side content is visible now
        show_side_content = abap_true.
        show_side_btn     = abap_false.
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the sample's own feed.json /EntryCollection, all four rows verbatim
    t_entrycollection = VALUE #(
      ( author       = `Alexandrina Victoria`
        authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`
        type         = `Request`
        date         = `March 03 2013`
        text         = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` )
      ( author       = `George Washington`
        authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`
        type         = `Reply`
        date         = `March 04 2013`
        text         = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore` )
      ( author       = `Alexandrina Victoria`
        authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`
        type         = `Request`
        date         = `March 05 2013`
        text         = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat` )
      ( author       = `George Washington`
        authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`
        type         = `Rejection`
        date         = `March 07 2013`
        text         = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` ) ).

  ENDMETHOD.

ENDCLASS.
