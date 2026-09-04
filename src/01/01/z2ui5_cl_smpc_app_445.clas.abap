" @keywords text sap.m texthyphenation simpleform label switch slider panel title blocklayout blocklayoutrow blocklayoutcell
" @summary The Text control has a property allowing hyphenation.
CLASS z2ui5_cl_smpc_app_445 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA hyphenate TYPE abap_bool VALUE abap_true.
    DATA width_pct TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_445 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " onHyphenationChange sets wrappingType Hyphenated/Normal on all five Texts -
    " one expression binding over the two-way bound Switch state does the same
    DATA wrapping_type TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    wrapping_type = |\{= ${ client->_bind( hyphenate ) } ? 'Hyphenated' : 'Normal' \}|.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.ui.layout.form`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `displayBlock` v = `true`

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `layout`          v = `ResponsiveGridLayout`
            )->a( n = `editable`        v = `true`
            )->a( n = `adjustLabelSpan` v = `false`
            )->a( n = `labelSpanXL`     v = `2`
            )->a( n = `labelSpanL`      v = `2`
            )->a( n = `labelSpanM`      v = `3`
            )->a( n = `labelSpanS`      v = `5`

            )->tag( `Label`
                )->a( n = `text` v = `Wrapping`
            )->tag( `Switch`
                )->a( n = `state`   v = `true`
                )->a( n = `enabled` v = `false`
            )->tag( `Label`
                )->a( n = `text` v = `Enable Hyphenation`
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( hyphenate )
            )->tag( `Label`
                )->a( n = `text` v = `Container Width`
            " onSliderMoved sets the Panel width to value + '%' - the liveChange wire is
            " dropped, the Panel width follows the bound value in an expression binding
            )->tag( `Slider`
                )->a( n = `id`    v = `widthSlider`
                )->a( n = `value` v = client->_bind( width_pct )

        )->end(

        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayout`
            )->a( n = `headerText` v = `sap.m.Text in container`
            )->a( n = `width`      v = |\{= ${ client->_bind( width_pct ) } + '%' \}|

            )->tag( `Text`
                )->a( n = `id`           v = `text0`
                )->a( n = `wrappingType` v = wrapping_type
                )->a( n = `text`         v = `An aggregation is a special relation between two UI element types. It is used to define the parent-child relationship within the ` &&
                                         `tree structure. The parent end of the aggregation has cardinality 0..1, while the child end may have 0..1 or 0..*. The element's ` &&
                                         `API offers convenient and consistent methods to deal with aggregations (e.g. to get, set, or remove target elements). Examples are` &&
                                         ` table rows and cells, or the content of a table cell.`

        )->end(

        )->tag( `Title`
            )->a( n = `titleStyle` v = `H4`
            )->a( n = `text`       v = `sap.m.Text in sap.ui.layout.BlockLayout`
            )->a( n = `class`      v = `sapUiSmallMargin`

        )->ele( n = `BlockLayout` ns = `l`
            )->a( n = `id`         v = `BlockLayout`
            )->a( n = `background` v = `Light`

            )->ele( n = `BlockLayoutRow` ns = `l`
                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `title` v = `Aggregation`

                    )->tag( `Text`
                        )->a( n = `id`           v = `text1`
                        )->a( n = `wrappingType` v = wrapping_type
                        )->a( n = `text`         v = `An aggregation is a special relation between two UI element types. It is used to define the parent-child relationship within the ` &&
                                             `tree structure. The parent end of the aggregation has cardinality 0..1, while the child end may have 0..1 or 0..*. The element's ` &&
                                             `API offers convenient and consistent methods to deal with aggregations (e.g. to get, set, or remove target elements). Examples are` &&
                                             ` table rows and cells, or the content of a table cell.`

                )->end(

                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `title` v = `Association`

                    )->tag( `Text`
                        )->a( n = `id`           v = `text2`
                        )->a( n = `wrappingType` v = wrapping_type
                        )->a( n = `text`         v = `An association is a type of relation between two UI element types which is independent of the parent-child relationship within the` &&
                                             ` tree structure. Directed outgoing associations to a target of cardinality 0..1 are supported. They represent a loose coupling ` &&
                                             `only and are thus implemented by storing the target element instance's ID. The most prominent example is the association between a` &&
                                             ` label and its field.`

                )->end(

                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `title` v = `Asynchronous (async) processing`

                    )->tag( `Text`
                        )->a( n = `id`           v = `text3`
                        )->a( n = `wrappingType` v = wrapping_type
                        )->a( n = `text`         v = `In contrast to synchronous processing this processing mode does not keep the browser thread busy but does the processing in the ` &&
                                             `background and continues with the next task. Code can be executed asynchronously and a callback function is triggered when a ` &&
                                             `certain condition is met. Similarly, a file can be loaded asynchronously. Asynchronous processing is highly recommended for ` &&
                                             `performance reasons and to not freeze the UI.`

                )->end(

                )->ele( n = `BlockLayoutCell` ns = `l`
                    )->a( n = `title` v = `Bootstrap`

                    )->tag( `Text`
                        )->a( n = `id`           v = `text4`
                        )->a( n = `wrappingType` v = wrapping_type
                        )->a( n = `text`         v = `To use the UI5 features in your web page, you have to load and initialize – or bootstrap – the UI5 runtime in your HTML page.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
