" @keywords splitter sap.ui.layout html app button splitterlayoutdata horizontallayout text verticallayout hbox checkbox input
" @summary Splitter where you can change contentAreas and their sizes live
CLASS z2ui5_cl_smpc_app_351 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " one row per Splitter content area. The original declares three of them in
    " the view and creates/removes more from the controller; here the Splitter's
    " contentAreas AND the options layout below it are both bound to this table,
    " so a row is the single source of truth for an area and its option row
    TYPES:
      BEGIN OF ty_s_area,
        title        TYPE string,
        text         TYPE string,
        size         TYPE string,
        minsize      TYPE i,
        minsize_text TYPE string,
        resizable    TYPE abap_bool,
      END OF ty_s_area,
      ty_t_area TYPE STANDARD TABLE OF ty_s_area WITH EMPTY KEY.
    DATA t_areas TYPE ty_t_area.

    " sap.ui.layout.Splitter.orientation - the property btnChangeOrientation
    " flips imperatively in the original
    DATA orientation TYPE string.

    " the eventStatus Text the resize event writes
    DATA eventstatus TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the original's iResizes counter; not bound, so it stays out of the model
    DATA resizes TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_351 IMPLEMENTATION.

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

    " the Splitter with its content areas and the options layout below it are
    " both bound to t_areas - the original declares three areas in the view and
    " builds the options rows in showLayoutOptions( ). Binding both to the same
    " table is what makes Resizable / Size / Min-Size drive the layout data
    " without a single imperative setter. css/splitter.css is injected as a
    " core:HTML style leaf.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns`        v = `sap.m`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.options\{margin:1rem 2rem\}.options .paddingRight\{padding-right:0.5rem\}` &&
                                    `.optionTitle\{font-weight:bold;margin-right:4rem\}</style>`

        )->ele( `App`
            )->ele( `Page`
                )->a( n = `showHeader` v = `false`

                )->ele( n = `Splitter` ns = `l`
                    )->a( n = `id`           v = `mainSplitter`
                    )->a( n = `height`       v = `500px`
                    )->a( n = `width`        v = `100%`
                    )->a( n = `orientation`  v = client->_bind( orientation )
                    )->a( n = `contentAreas` v = client->_bind( t_areas )
                    )->a( n = `resize`       v = client->_event( `RESIZE` )

                    )->ele( `Button`
                        )->a( n = `width` v = `100%`
                        )->a( n = `text`  v = `{TEXT}`

                        )->ele( `layoutData`
                            )->tag( n = `SplitterLayoutData` ns = `l`
                                )->a( n = `size`      v = `{SIZE}`
                                )->a( n = `minSize`   v = `{MINSIZE}`
                                )->a( n = `resizable` v = `{RESIZABLE}`

                        )->end(
                    )->end(
                )->end(
                )->ele( n = `HorizontalLayout` ns = `l`
                    )->a( n = `class` v = `sapUiSmallMarginTop sapUiSmallMarginBegin`

                    )->tag( `Button`
                        )->a( n = `text`  v = `Add content area`
                        )->a( n = `press` v = client->_event( `ADD_AREA` )

                    )->tag( `Button`
                        )->a( n = `text`  v = `Remove content area`
                        )->a( n = `press` v = client->_event( `REMOVE_AREA` )

                    )->tag( `Button`
                        )->a( n = `text`  v = `Invalidate Splitter`
                        )->a( n = `press` v = client->_event( `INVALIDATE` )

                    )->tag( `Button`
                        )->a( n = `text`  v = `Change Orientation`
                        )->a( n = `press` v = client->_event( `CHANGE_ORIENTATION` )

                    )->tag( `Text`
                        )->a( n = `id`    v = `eventStatus`
                        )->a( n = `text`  v = client->_bind( eventstatus )
                        )->a( n = `class` v = `sapUiTinyMarginTop sapUiTinyMarginBegin`

                )->end(
                )->ele( n = `VerticalLayout` ns = `l`
                    )->a( n = `id`      v = `mainOptions`
                    )->a( n = `class`   v = `options`
                    )->a( n = `content` v = client->_bind( t_areas )

                    )->ele( `HBox`
                        )->a( n = `alignItems` v = `Center`

                        )->tag( `Text`
                            )->a( n = `text`  v = `{TITLE}`
                            )->a( n = `class` v = `optionTitle`

                        )->tag( `Text`
                            )->a( n = `text` v = `Resizable: `

                        )->tag( `CheckBox`
                            )->a( n = `selected` v = `{RESIZABLE}`
                            )->a( n = `class`    v = `paddingRight`

                        )->tag( `Text`
                            )->a( n = `text` v = `Size (CSS): `

                        )->tag( `Input`
                            )->a( n = `value` v = `{SIZE}`
                            )->a( n = `class` v = `paddingRight`

                        )->tag( `Text`
                            )->a( n = `text` v = `Min-Size: (in px)`

                        )->tag( `Input`
                            )->a( n = `value`  v = `{MINSIZE_TEXT}`
                            )->a( n = `change` v = client->_event( `MINSIZE_CHANGED` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ADD_AREA`.
        " createExampleContent + addContentArea: the original randomizes size
        " and maxSize; a deterministic rotation is used here (the corpus rule
        " for random/now values), so the port renders the same every run
        INSERT VALUE #( text         = `Content!`
                        size         = COND #( WHEN lines( t_areas ) MOD 2 = 0 THEN `auto` ELSE `150px` )
                        minsize      = 0
                        minsize_text = `0`
                        resizable    = abap_true )
               INTO TABLE t_areas.

      WHEN `REMOVE_AREA`.
        " removeContentArea( getContentAreas( ).pop( ) )
        IF t_areas IS NOT INITIAL.
          DELETE t_areas INDEX lines( t_areas ).
        ENDIF.

      WHEN `INVALIDATE`.
        " btnInvalidateSplitter forces a re-render without changing a
        " property. invalidate( ) itself is denied by the frontend action
        " allowlist (the render lifecycle is the framework's), and it is not
        " needed: the round-trip this event already is ends in the automatic
        " model push, which re-renders the slot

      WHEN `CHANGE_ORIENTATION`.
        " btnChangeOrientation flips Splitter.orientation, which IS a bindable
        " property - so the flip happens on the model, not through a setter
        orientation = COND #( WHEN orientation = `Horizontal` THEN `Vertical` ELSE `Horizontal` ).

      WHEN `RESIZE`.
        " the controller's resize handler: a running counter plus the current
        " local time, written into the eventStatus Text
        resizes = resizes + 1.
        eventstatus = |{ sy-datum DATE = USER } { sy-uzeit TIME = USER } - Resize # { resizes }|.

      WHEN `MINSIZE_CHANGED`.
        " the Min-Size Input carries a STRING while SplitterLayoutData.minSize
        " is an integer; the original parses it with parseInt in the handler,
        " here the parse happens in ABAP over the whole (already two-way
        " returned) table - no per-row index has to travel
        LOOP AT t_areas REFERENCE INTO DATA(lr_area).
          lr_area->minsize = COND i( WHEN lr_area->minsize_text CO ` 0123456789`
                                     THEN CONV i( lr_area->minsize_text ) ).
        ENDLOOP.

    ENDCASE.

    " every area row carries its own option row, so the titles follow the table
    LOOP AT t_areas REFERENCE INTO DATA(lr_row).
      lr_row->title = |ContentArea #{ sy-tabix }|.
    ENDLOOP.


  ENDMETHOD.


  METHOD model_init.

    " the three content areas the original declares in the view, with their
    " SplitterLayoutData; resizable defaults to true on all of them
    t_areas = VALUE #( resizable = abap_true
                       ( title = `ContentArea #1` text = `Content 1` size = `300px` minsize = 0   minsize_text = `0` )
                       ( title = `ContentArea #2` text = `Content 2` size = `auto`  minsize = 0   minsize_text = `0` )
                       ( title = `ContentArea #3` text = `Content 3` size = `30%`   minsize = 200 minsize_text = `200` ) ).

    " Splitter.orientation default, and the Text's initial label
    orientation = `Horizontal`.
    eventstatus = `Nothing happened so far...`.

  ENDMETHOD.

ENDCLASS.
