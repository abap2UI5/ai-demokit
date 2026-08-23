" @keywords tree sap.m treeexpandmulti overflowtoolbar title toolbarspacer button multicombobox item togglebutton standardtreeitem
" @summary This example shows how to expand/collapse multiple nodes and demonstrates the sticky header toolbar and info toolbar options.
CLASS z2ui5_cl_smpc_app_601 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node_level5,
        text TYPE string,
        ref  TYPE string,
      END OF ty_s_node_level5,
      BEGIN OF ty_s_node_level4,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level5 WITH EMPTY KEY,
      END OF ty_s_node_level4,
      BEGIN OF ty_s_node_level3,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level4 WITH EMPTY KEY,
      END OF ty_s_node_level3,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level3 WITH EMPTY KEY,
      END OF ty_s_node_level2,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level2 WITH EMPTY KEY,
      END OF ty_s_node_level1.
    TYPES ty_t_string TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    DATA t_nodes  TYPE STANDARD TABLE OF ty_s_node_level1 WITH EMPTY KEY.
    " the MultiComboBox selection and the Tree's sticky property share one table
    DATA t_sticky TYPE ty_t_string.
    " the ToggleButton's pressed state; the info toolbar hides while it is set
    DATA hide_info TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_601 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->ele( `Tree`
            )->a( n = `id`     v = `Tree`
            " items path '/' - bind the root table; the nested `nodes` drive the depth
            )->a( n = `items`  v = client->_bind( t_nodes )
            )->a( n = `mode`   v = `MultiSelect`
            " onSelectionFinish maps the picked keys onto tree.setSticky( ) - the
            " MultiComboBox selection and the sticky property share one bound table
            )->a( n = `sticky` v = client->_bind( t_sticky )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->ele( `content`
                        )->tag( `Title`
                            )->a( n = `text` v = `Tree Nodes`
                        )->tag( `ToolbarSpacer`

                        " expand / collapse take the selected INDICES; the resolved
                        " array reaches the public methods through castArgAuto
                        " untouched (app 248 idiom, e2e-verified there)
                        )->tag( `Button`
                            )->a( n = `id`    v = `expandMulti`
                            )->a( n = `text`  v = `expand selected nodes`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `Tree` )
                                                                                             ( `expand` )
                                                                                             ( `$event.oSource.getParent().getParent().getSelectedItems().map(function (o) { return $event.oSource.getParent().getParent().indexOfItem(o); })` ) ) )
                        )->tag( `Button`
                            )->a( n = `id`    v = `collapseMulti`
                            )->a( n = `text`  v = `collapse selected nodes`
                            )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `Tree` )
                                                                                             ( `collapse` )
                                                                                             ( `$event.oSource.getParent().getParent().getSelectedItems().map(function (o) { return $event.oSource.getParent().getParent().indexOfItem(o); })` ) ) )

                        )->ele( `MultiComboBox`
                            )->a( n = `id`           v = `idSticky`
                            )->a( n = `placeholder`  v = `Sticky options`
                            )->a( n = `selectedKeys` v = client->_bind( t_sticky )
                            )->a( n = `width`        v = `15%`
                            )->ele( `items`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Header Toolbar`
                                    )->a( n = `key`  v = `HeaderToolbar`
                                )->tag( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Info Toolbar`
                                    )->a( n = `key`  v = `InfoToolbar`
                            )->end(
                        )->end(

                        " onToggleInfoToolbar sets the info toolbar's visible to the
                        " NEGATION of the button's pressed state; both are bindable,
                        " so the two share one flag and no round trip is needed
                        )->tag( `ToggleButton`
                            )->a( n = `id`      v = `toggleInfoToolbar`
                            )->a( n = `text`    v = `Hide/Show InfoToolbar`
                            )->a( n = `pressed` v = client->_bind( hide_info )
                    )->end(
                )->end(
            )->end(

            )->ele( `infoToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `visible` v = |\{= !${ client->_bind( hide_info ) } \}|
                    )->ele( `content`
                        )->tag( `Title`
                            )->a( n = `text` v = `Tree's info toolbar`
                    )->end(
                )->end(
            )->end(

            )->tag( `StandardTreeItem`
                )->a( n = `title` v = `{TEXT}` ).

    " onInit does tree.expandToLevel( 1 ) - roundtrip-free frontend action
    " (expandToLevel is whitelisted, app 248/365 idiom)
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `Tree` ) ( `expandToLevel` ) ( `1` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_nodes = VALUE #(
        ( text  = `Node1`
          ref   = `sap-icon://attachment-audio`
          nodes = VALUE #(
              ( text  = `Node1-1`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-1-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-1-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-1-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-1-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-1-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-1-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-2`
                ref   = `sap-icon://create`
                nodes = VALUE #(
                    ( text = `Node1-2-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-2-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-2-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-2-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-2-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-2-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-3`
                ref   = `sap-icon://create`
                nodes = VALUE #(
                    ( text = `Node1-3-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-3-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-3-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-3-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-3-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-3-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-4`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-1-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-1-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-1-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-1-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-1-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-1-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-5`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-1-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-1-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-1-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-1-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-1-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-1-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text  = `Node1-6`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-1-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-1-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-1-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-1-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-1-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-1-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) ) ) )
        ( text = `Node2`
          ref  = `sap-icon://customer-financial-fact-sheet` ) ).

  ENDMETHOD.

ENDCLASS.
