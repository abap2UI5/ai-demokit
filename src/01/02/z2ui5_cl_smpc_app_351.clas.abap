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
      ty_t_area TYPE STANDARD TABLE OF ty_s_area WITH DEFAULT KEY.
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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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
        DATA temp1 TYPE z2ui5_cl_smpc_app_351=>ty_s_area.
        DATA temp6 TYPE z2ui5_cl_smpc_app_351=>ty_s_area-size.
        DATA temp2 TYPE string.
        DATA temp3 LIKE LINE OF t_areas.
        DATA lr_area LIKE REF TO temp3.
          DATA temp4 TYPE i.
          DATA temp7 TYPE i.
    DATA temp5 LIKE LINE OF t_areas.
    DATA lr_row LIKE REF TO temp5.

    CASE client->get_event( ).

      WHEN `ADD_AREA`.
        " createExampleContent + addContentArea: the original randomizes size
        " and maxSize; a deterministic rotation is used here (the corpus rule
        " for random/now values), so the port renders the same every run
        
        CLEAR temp1.
        temp1-text = `Content!`.
        
        IF lines( t_areas ) MOD 2 = 0.
          temp6 = `auto`.
        ELSE.
          temp6 = `150px`.
        ENDIF.
        temp1-size = temp6.
        temp1-minsize = 0.
        temp1-minsize_text = `0`.
        temp1-resizable = abap_true.
        INSERT temp1
               INTO TABLE t_areas.

      WHEN `REMOVE_AREA`.
        " removeContentArea( getContentAreas( ).pop( ) )
        IF t_areas IS NOT INITIAL.
          DELETE t_areas INDEX lines( t_areas ).
        ENDIF.

      WHEN `INVALIDATE`.
        " btnInvalidateSplitter forces a re-render without changing a property.
        " invalidate( ) itself is denied by the frontend action allowlist (the
        " render lifecycle is the framework's), so the slot is re-displayed
        " instead - which IS a re-render, and the sizes come back off the model.
        " This branch was empty until 2026-08-24, on the reasoning that "the
        " round-trip this event already is ends in the automatic model push".
        " It does not: main_end sends a model only when a slot displayed XML or
        " when main( ) actually CHANGED the model, and this branch changed
        " nothing, so the response carried an empty model and the button did
        " nothing at all.
        view_display( ).

      WHEN `CHANGE_ORIENTATION`.
        " btnChangeOrientation flips Splitter.orientation, which IS a bindable
        " property - so the flip happens on the model, not through a setter
        
        IF orientation = `Horizontal`.
          temp2 = `Vertical`.
        ELSE.
          temp2 = `Horizontal`.
        ENDIF.
        orientation = temp2.

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
        
        
        LOOP AT t_areas REFERENCE INTO lr_area.
          " the length term, not just the character one - `99999999999` is all
          " digits and overflows CONV i
          
          temp4 = lr_area->minsize_text.
          
          IF lr_area->minsize_text CO ` 0123456789` AND strlen( condense( lr_area->minsize_text ) ) <= 9.
            temp7 = temp4.
          ELSE.
            CLEAR temp7.
          ENDIF.
          lr_area->minsize = temp7.
        ENDLOOP.

    ENDCASE.

    " every area row carries its own option row, so the titles follow the table
    
    
    LOOP AT t_areas REFERENCE INTO lr_row.
      lr_row->title = |ContentArea #{ sy-tabix }|.
    ENDLOOP.


  ENDMETHOD.


  METHOD model_init.

    " the three content areas the original declares in the view, with their
    " SplitterLayoutData; resizable defaults to true on all of them
    DATA temp6 TYPE z2ui5_cl_smpc_app_351=>ty_t_area.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp6.
    
    temp7-resizable = abap_true.
    temp7-title = `ContentArea #1`.
    temp7-text = `Content 1`.
    temp7-size = `300px`.
    temp7-minsize = 0.
    temp7-minsize_text = `0`.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `ContentArea #2`.
    temp7-text = `Content 2`.
    temp7-size = `auto`.
    temp7-minsize = 0.
    temp7-minsize_text = `0`.
    INSERT temp7 INTO TABLE temp6.
    temp7-title = `ContentArea #3`.
    temp7-text = `Content 3`.
    temp7-size = `30%`.
    temp7-minsize = 200.
    temp7-minsize_text = `200`.
    INSERT temp7 INTO TABLE temp6.
    t_areas = temp6.

    " Splitter.orientation default, and the Text's initial label
    orientation = `Horizontal`.
    eventstatus = `Nothing happened so far...`.

  ENDMETHOD.

ENDCLASS.
