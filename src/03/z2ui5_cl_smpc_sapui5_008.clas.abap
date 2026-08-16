"! <p class="shorttext">sap.suite.ui.commons - networkgraph.Graph</p>
"!
"! SAPUI5-only control: it ships with SAPUI5, not with OpenUI5, so there is no
"! demo kit original in this repo's sample universe and no 1:1 port (AGENTS section 3).
"! Collected here as orientation - how the control is expressed in abap2UI5.
"!
"! SAPUI5 demo kit: https://ui5.sap.com/#/entity/sap.suite.ui.commons.networkgraph.Graph
CLASS z2ui5_cl_smpc_sapui5_008 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_attributes3,
             label TYPE i,
             value TYPE string,
           END OF ty_s_attributes3.
    TYPES ty_t_attributes3 TYPE STANDARD TABLE OF ty_s_attributes3 WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_nodes2,
             id         TYPE string,
             title      TYPE string,
             src        TYPE string,
             attributes TYPE ty_t_attributes3,
             team       TYPE i,
             supervisor TYPE string,
             location   TYPE string,
             position   TYPE string,
             email      TYPE string,
             phone      TYPE string,
           END OF ty_s_nodes2.
    TYPES: BEGIN OF ty_s_lines4,
             from TYPE string,
             to   TYPE string,
           END OF ty_s_lines4.
    TYPES ty_t_nodes2 TYPE STANDARD TABLE OF ty_s_nodes2 WITH EMPTY KEY.
    TYPES ty_t_lines4 TYPE STANDARD TABLE OF ty_s_lines4 WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_json1,
             nodes TYPE ty_t_nodes2,
             lines TYPE ty_t_lines4,
           END OF ty_s_json1.
    DATA mt_data TYPE ty_s_json1.

    METHODS on_event.
    METHODS view_display.
    METHODS detail_popover
      IMPORTING
        id   TYPE string
        node TYPE ty_s_nodes2.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_smpc_sapui5_008 IMPLEMENTATION.

  METHOD detail_popover.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(group) = view->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `QuickView`
            )->a( n = `placement` v = `Left`

            )->ele( `QuickViewPage`
                )->a( n = `header`      v = `Employee`
                )->a( n = `title`       v = node-title
                )->a( n = `description` v = node-position

                )->ele( `avatar`
                    )->tag( `Avatar`
                        )->a( n = `src`          v = node-src
                        )->a( n = `displayShape` v = `Square`

                )->end(

                )->ele( `QuickViewGroup`
                    )->a( n = `heading` v = `Contact Detail`

                    )->tag( `QuickViewGroupElement`
                        )->a( n = `label` v = `Location`
                        )->a( n = `value` v = node-location
                    )->tag( `QuickViewGroupElement`
                        )->a( n = `label` v = `Mobile`
                        )->a( n = `value` v = node-phone
                        )->a( n = `type`  v = `phone`
                    )->tag( `QuickViewGroupElement`
                        )->a( n = `label`        v = `Email`
                        )->a( n = `value`        v = node-email
                        )->a( n = `type`         v = `email`
                        )->a( n = `emailSubject` v = |Contact{ node-id }|

                )->end( ).

    IF node-team IS NOT INITIAL.
      group->ele( `QuickViewGroup`
          )->a( n = `heading` v = `Team`

          )->tag( `QuickViewGroupElement`
              )->a( n = `label` v = `Size`
              )->a( n = `value` v = CONV string( node-team ) ).
    ENDIF.

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN `LINE_PRESS`.
        client->message_toast_display( `LINE_PRESSED` ).

      WHEN `DETAIL_POPOVER`.
        DATA(lt_arg) = client->get( )-t_event_arg.

        READ TABLE mt_data-nodes INTO DATA(ls_node) WITH KEY id = lt_arg[ 2 ].

        IF sy-subrc = 0.
          detail_popover( id   = lt_arg[ 1 ]
                          node = ls_node ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock`      v = `true`
        )->a( n = `height`            v = `100%`
        )->a( n = `xmlns`             v = `sap.m`
        )->a( n = `xmlns:mvc`         v = `sap.ui.core.mvc`
        )->a( n = `xmlns:networkgraph` v = `sap.suite.ui.commons.networkgraph`
        )->a( n = `xmlns:nglayout`    v = `sap.suite.ui.commons.networkgraph.layout`

        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Network Graph - Org Tree`
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )

            )->ele( n = `Graph` ns = `networkgraph`
                )->a( n = `id`              v = `graph`
                )->a( n = `orientation`     v = `TopBottom`
                )->a( n = `nodes`           v = client->_bind( mt_data-nodes )
                )->a( n = `lines`           v = client->_bind( mt_data-lines )
                )->a( n = `layout`          v = `Layered`
                )->a( n = `searchSuggest`   v = `suggest`
                )->a( n = `search`          v = `search`
                )->a( n = `enableWheelZoom` b = abap_false

                )->ele( n = `layoutAlgorithm` ns = `networkgraph`
                    )->tag( n = `LayeredLayout` ns = `nglayout`
                        )->a( n = `nodePlacement` v = `Simple`
                        )->a( n = `nodeSpacing`   v = `40`
                        )->a( n = `mergeEdges`    b = abap_true

                )->end(

                )->ele( n = `nodes` ns = `networkgraph`
                    )->ele( n = `Node` ns = `networkgraph`
                        )->a( n = `icon`                  v = `sap-icon://action-settings`
                        )->a( n = `key`                   v = `{ID}`
                        )->a( n = `description`           v = `{TITLE}`
                        )->a( n = `title`                 v = `{TITLE}`
                        )->a( n = `width`                 v = `90`
                        )->a( n = `collapsed`             v = `{COLLAPSED}`
                        )->a( n = `attributes`            v = `{ATTRIBUTES}`
                        )->a( n = `descriptionLineSize`   v = `0`
                        )->a( n = `shape`                 v = `Box`
                        )->a( n = `showActionLinksButton` b = abap_false
                        )->a( n = `showDetailButton`      b = abap_false

                        )->ele( n = `attributes` ns = `networkgraph`
                            )->tag( n = `ElementAttribute` ns = `networkgraph`
                                )->a( n = `label` v = `{LABEL}`
                                )->a( n = `value` v = `{VALUE}`

                        )->end(

                        )->ele( `actionButtons`
                            )->tag( n = `ActionButton` ns = `networkgraph`
                                " the id is deliberately not set: the graph assigns one, and the
                                " press handler reads it back through ${$source>/id}
                                )->a( n = `position` v = `Left`
                                )->a( n = `title`    v = `Detail`
                                )->a( n = `icon`     v = `sap-icon://employee`
                                )->a( n = `press`    v = client->_event( val   = `DETAIL_POPOVER`
                                                                        t_arg = VALUE #( ( `${$source>/id}` )
                                                                                         ( `${ID}` ) ) )

                        )->end(

                        )->ele( n = `image` ns = `networkgraph`
                            )->tag( n = `NodeImage` ns = `networkgraph`
                                )->a( n = `src`    v = `{SRC}`
                                )->a( n = `width`  v = `80`
                                )->a( n = `height` v = `100`

                        )->end(
                    )->end(
                )->end(

                )->ele( `lines`
                    )->tag( n = `Line` ns = `networkgraph`
                        )->a( n = `from`             v = `{FROM}`
                        )->a( n = `to`               v = `{TO}`
                        )->a( n = `arrowOrientation` v = `None`
                        )->a( n = `press`            v = client->_event( `LINE_PRESS` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      mt_data = VALUE #( nodes             = VALUE #( ( id = `Dinter`
                                            title          = `Sophie Dinter`
                                            src            = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/female_IngallsB.jpg`
                                            attributes     = VALUE #( ( label = 35 value = `` ) )
                                            team           = 13
                                            location       = `Walldorf`
                                            position       = `lobal Solutions Manager`
                                            email          = `sophie.dinter@example.com`
                                            phone          = `+000 423 230 000`
                                          )
                                          ( id         = `Ninsei`
                                            title      = `Yamasaki Ninsei`
                                            src        = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/male_GordonR.jpg`
                                            attributes = VALUE #( ( label = 9 value = `` ) )
                                            supervisor = `Dinter`
                                            team       = 9
                                            location   = `Walldorf`
                                            position   = `Lead Markets Manage`
                                            email      = `yamasaki.ninsei@example.com`
                                            phone      = `+000 423 230 002`
                                         )
                                         ( id         = `Mills`
                                           title      = `Henry Mills`
                                           src        = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/male_MillerM.jpg`
                                           attributes = VALUE #( ( label = 4 value = `` ) )
                                           supervisor = `Ninsei`
                                           team       = 4
                                           location   = `Praha`
                                           position   = `Sales Manager`
                                           email      = `henry.mills@example.com`
                                           phone      = `+000 423 232 003`
                                        )
                                        ( id         = `Polak`
                                          title      = `Adam Polak`
                                          src        = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/male_PlatteR.jpg`
                                          supervisor = `Mills`
                                          location   = `Praha`
                                          position   = `Marketing Specialist`
                                          email      = `adam.polak@example.com`
                                          phone      = `+000 423 232 004`
                                       )
                                       ( id          = `Sykorova`
                                          title      = `Vlasta Sykorova`
                                          src        = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/female_SpringS.jpg`
                                          supervisor = `Mills`
                                          location   = `Praha`
                                          position   = `Human Assurance Officer`
                                          email      = `vlasta.sykorova@example.com`
                                          phone      = `+000 423 232 005`
                                       )
                                     )
                                     lines = VALUE #( ( from = `Dinter` to = `Ninsei` )
                                                      ( from = `Ninsei` to = `Mills` )
                                                      ( from = `Mills` to = `Polak` )
                                                      ( from = `Mills` to = `Sykorova` )
                                    ) ).

      view_display( ).

    ENDIF.

    on_event( ).

  ENDMETHOD.

ENDCLASS.
