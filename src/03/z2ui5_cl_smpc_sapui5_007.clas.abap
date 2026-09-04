" @keywords timeline shell timelineitem
" @summary sap.suite.ui.commons.Timeline expressed in abap2UI5 - a SAPUI5-only control, so the demo kit original is outside OpenUI5 and this is orientation rather than a 1:1 port.
"! <p class="shorttext">sap.suite.ui.commons - Timeline</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.commons.Timeline
CLASS z2ui5_cl_smpc_sapui5_007 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_feed,
        author    TYPE string,
        title     TYPE string,
        authorpic TYPE string,
        type      TYPE string,
        date      TYPE string,
        datetime  TYPE string,
        text      TYPE string,
      END OF ty_s_feed.
    DATA mt_feed TYPE STANDARD TABLE OF ty_s_feed WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_007 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      set_data( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.

  METHOD set_data.

    DATA temp1 LIKE mt_feed.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-author = `Developer9`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.11.2023`.
    temp2-text = `newest entry`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer8`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.10.2023`.
    temp2-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer7`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.09.2023`.
    temp2-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer6`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.08.2023`.
    temp2-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer5`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.07.2023`.
    temp2-text = `this is a text`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer4`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.06.2023`.
    temp2-text = `this is another entry Product D`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer3`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.05.2023`.
    temp2-text = `this is another entry Product C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer2`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.04.2023`.
    temp2-text = `this is another entry Product B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer1`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-datetime = `01.03.2023`.
    temp2-text = `this is another entry Product A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-author = `Developer`.
    temp2-title = `this is a title`.
    temp2-datetime = `01.02.2023`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Request`.
    temp2-date = `August 26 2023`.
    temp2-text =
`this is a long text Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna` &&
`aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `first entry`.
    temp2-author = `Developer`.
    temp2-datetime = `01.01.2023`.
    temp2-authorpic = `sap-icon://employee`.
    temp2-type = `Reply`.
    temp2-date = `August 26 2023`.
    temp2-text = `this is the beginning of a timeline`.
    INSERT temp2 INTO TABLE temp1.
    mt_feed = temp1.

  ENDMETHOD.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`   v = `true`
        )->a( n = `height`         v = `100%`
        )->a( n = `xmlns`          v = `sap.m`
        )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
        )->a( n = `xmlns:commons`  v = `sap.suite.ui.commons`

        )->ele( `Shell`
            )->ele( `Page`
                )->a( n = `title`          v = `Timeline`
                )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                )->a( n = `showNavButton`  b = client->check_app_prev_stack( )

                )->ele( n = `Timeline` ns = `commons`
                    )->a( n = `content` v = client->_bind( mt_feed )

                    )->ele( n = `content` ns = `commons`
                        )->tag( n = `TimelineItem` ns = `commons`
                            )->a( n = `dateTime`    v = `{DATETIME}`
                            )->a( n = `title`       v = `{TITLE}`
                            )->a( n = `userPicture` v = `{AUTHORPIC}`
                            )->a( n = `text`        v = `{TEXT}`
                            )->a( n = `userName`    v = `{AUTHOR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
