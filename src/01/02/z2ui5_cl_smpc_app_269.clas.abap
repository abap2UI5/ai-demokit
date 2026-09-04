" @keywords dynamicsidecontent dynamic side content sap.ui.layout dynamicsidecontentproduct html vbox title image text toolbar
" @summary Product page with comments example.
CLASS z2ui5_cl_smpc_app_269 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_entry,
             author       TYPE string,
             authorpicurl TYPE string,
             type         TYPE string,
             date         TYPE string,
             text         TYPE string,
           END OF ty_s_entry.

    TYPES temp1_33a31fc2c4 TYPE STANDARD TABLE OF ty_s_entry WITH DEFAULT KEY.
DATA t_entrycollection  TYPE temp1_33a31fc2c4.
    DATA toggle_enabled     TYPE abap_bool.
    DATA show_side_btn      TYPE abap_bool.
    DATA show_side_content  TYPE abap_bool VALUE abap_true.
    " the last breakpoint the control reported - updateShowSideContentButtonVisibility
    " reads getCurrentBreakpoint( ) in EVERY call site, not only in the event handler
    DATA breakpoint         TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_269 IMPLEMENTATION.

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
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " The controller's media model (new JSONModel(Device.system)) is the shared
    " device> model here, so {media>/phone} becomes {device>/system/phone}.
    " toggle()/setShowSideContent() are public control methods driven through
    " control_by_id; the breakpointChanged round-trip keeps the two button
    " flags in sync exactly like updateToggleButtonState /
    " updateShowSideContentButtonVisibility.
    
    CLEAR temp1.
    INSERT `DynamicSideContent` INTO TABLE temp1.
    INSERT `toggle` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `sideContentContainer` INTO TABLE temp2.
    INSERT `css` INTO TABLE temp2.
    INSERT `width` INTO TABLE temp2.
    INSERT `${$parameters>/value} + '%'` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        " the sample's own style.css - the view carries sapUiDSCExplored and the
        " rules behind them have to come with it (apps 122/124/133/138).
        " \{ \} escaped: the XMLView parser reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapUiDSC.sapUiDSCExplored h1\{font-size:2rem\}</style>`

        )->ele( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`

            )->ele( `Page`
                )->a( n = `id`            v = `sideContentContainer`
                )->a( n = `showHeader`    v = `false`
                )->a( n = `showNavButton` v = `false`

                )->ele( n = `DynamicSideContent` ns = `l`
                    )->a( n = `id`                  v = `DynamicSideContent`
                    )->a( n = `class`               v = `sapUiDSCExplored sapUiContentPadding`
                    )->a( n = `containerQuery`      v = `true`
                    )->a( n = `showSideContent`     v = client->_bind( show_side_content )
                    )->a( n = `sideContentFallDown` v = `BelowM`
                    )->a( n = `breakpointChanged`   v = client->_event( val = `BREAKPOINT_CHANGED` arg = `${$parameters>/currentBreakpoint}` )

                    )->ele( `VBox`
                        )->tag( `Title`
                            )->a( n = `level` v = `H1`
                            )->a( n = `text`  v = `Product`
                        )->tag( `Image`
                            )->a( n = `src`          v = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                            )->a( n = `densityAware` v = `false`
                            )->a( n = `width`        v = `10em`
                        )->tag( `Text`
                            )->a( n = `text` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor `
                                              && `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud `
                                              && `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure `
                                              && `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.`
                                              && ` Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt `
                                              && `mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, `
                                              && `sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim `
                                              && `veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo `
                                              && `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum `
                                              && `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt `
                                              && `in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, `
                                              && `consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore `
                                              && `magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi `
                                              && `ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in `
                                              && `voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat `
                                              && `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`
                                              && ` Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor `
                                              && `incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud `
                                              && `exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure `
                                              && `dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.`
                                              && ` Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt `
                                              && `mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, `
                                              && `sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim `
                                              && `veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo `
                                              && `consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum `
                                              && `dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt `
                                              && `in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, `
                                              && `consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore `
                                              && `magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi `
                                              && `ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in `
                                              && `voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat `
                                              && `cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`

                    )->end(

                    )->ele( n = `sideContent` ns = `l`
                        )->ele( `Toolbar`
                            )->tag( `Title`
                                )->a( n = `text` v = `Comments`
                            )->tag( `ToolbarSpacer`
                            )->tag( `Button`
                                )->a( n = `text`    v = `Close`
                                )->a( n = `type`    v = `Transparent`
                                )->a( n = `visible` v = |\{= !$\{device>/system/phone\}\}|
                                )->a( n = `press`   v = client->_event( `SIDE_CONTENT_HIDE` )

                        )->end(

                        )->ele( n = `VerticalLayout` ns = `l`
                            )->a( n = `width` v = `100%`

                            )->ele( `List`
                                )->a( n = `items` v = client->_bind( t_entrycollection )

                                )->tag( `FeedListItem`
                                    )->a( n = `sender`    v = `{AUTHOR}`
                                    )->a( n = `icon`      v = `{AUTHORPICURL}`
                                    )->a( n = `info`      v = `{TYPE}`
                                    )->a( n = `timestamp` v = `{DATE}`
                                    )->a( n = `text`      v = `{TEXT}`

                            )->end(

                            )->tag( `FeedInput`
                                )->a( n = `showIcon` v = `true`
                                )->a( n = `icon`     v = `http://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `footer`
                )->ele( `Toolbar`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Toggle`
                        )->a( n = `type`    v = `Accept`
                        )->a( n = `id`      v = `toggleButton`
                        )->a( n = `enabled` v = client->_bind( toggle_enabled )
                        )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                          t_arg = temp1 )
                    )->tag( `Button`
                        )->a( n = `text`    v = `Open Side Content`
                        )->a( n = `id`      v = `showSideContentButton`
                        )->a( n = `visible` v = client->_bind( show_side_btn )
                        )->a( n = `press`   v = client->_event( `SIDE_CONTENT_SHOW` )
                    )->tag( `Slider`
                        )->a( n = `id`      v = `DSCWidthSlider`
                        )->a( n = `value`   v = `100`
                        )->a( n = `visible` v = |\{= !$\{device>/system/phone\}\}|
                        " handleSliderChange: the container is a sap.m.Page, which
                        " has no width property - the `css` control method writes
                        " the percentage onto its DOM node like the original jQuery
                        )->a( n = `liveChange` v = client->follow_up_action(
                                  val   = client->cs_event-control_by_id
                                  t_arg = temp2 )
                    )->tag( `Text`
                        )->a( n = `id`      v = `DSCWidthHintText`
                        )->a( n = `text`    v = `Best view in full screen`
                        )->a( n = `visible` v = |\{= !$\{device>/system/phone\}\}|

                        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE xsdboolean.
        DATA temp2 TYPE xsdboolean.
        DATA temp3 TYPE xsdboolean.

    CASE client->get_event( ).
      WHEN `BREAKPOINT_CHANGED`.
        " updateToggleButtonState: the Toggle button is enabled on S only.
        " updateShowSideContentButtonVisibility: bShowButton =
        " !(breakpoint === 'S' || isSideContentVisible( )) - both halves
        breakpoint     = client->get_event_arg( ).
        
        temp1 = boolc( breakpoint = `S` ).
        toggle_enabled = temp1.
        
        temp2 = boolc( breakpoint <> `S` AND show_side_content = abap_false ).
        show_side_btn  = temp2.

      WHEN `SIDE_CONTENT_HIDE`.
        " handleSideContentHide: setShowSideContent(false) + re-evaluate the
        " Open Side Content button. showSideContent is a bindable property, so
        " the flag is bound two-way and only flipped here
        show_side_content = abap_false.
        " !(breakpoint === 'S' || isSideContentVisible( )) - at S the button
        " stays hidden after Close, which an unconditional abap_true missed
        
        temp3 = boolc( breakpoint <> `S` ).
        show_side_btn     = temp3.

      WHEN `SIDE_CONTENT_SHOW`.
        " handleSideContentShow: setShowSideContent(true); the button hides
        " itself again because the side content is visible now
        show_side_content = abap_true.
        show_side_btn     = abap_false.
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the sample's own feed.json /EntryCollection, all four rows verbatim
    DATA temp3 LIKE t_entrycollection.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-author = `Alexandrina Victoria`.
    temp4-authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`.
    temp4-type = `Request`.
    temp4-date = `March 03 2013`.
    temp4-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et` &&
` accusam et justo duo dolores et ea rebum.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna ` &&
`aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod ` &&
`tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, ` &&
`consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo ` &&
`dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
`voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut ` &&
`labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.`.
    INSERT temp4 INTO TABLE temp3.
    temp4-author = `George Washington`.
    temp4-authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`.
    temp4-type = `Reply`.
    temp4-date = `March 04 2013`.
    temp4-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore`.
    INSERT temp4 INTO TABLE temp3.
    temp4-author = `Alexandrina Victoria`.
    temp4-authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`.
    temp4-type = `Request`.
    temp4-date = `March 05 2013`.
    temp4-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.
    INSERT temp4 INTO TABLE temp3.
    temp4-author = `George Washington`.
    temp4-authorpicurl = `http://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`.
    temp4-type = `Rejection`.
    temp4-date = `March 07 2013`.
    temp4-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.`.
    INSERT temp4 INTO TABLE temp3.
    t_entrycollection = temp3.

  ENDMETHOD.

ENDCLASS.
