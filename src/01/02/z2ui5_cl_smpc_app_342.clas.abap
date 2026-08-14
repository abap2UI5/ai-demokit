CLASS z2ui5_cl_smpc_app_342 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " one row per Card the controller creates: the original builds them in JS
    " (new Card({ manifest, layoutData, dataMode })) and adds them to the
    " GridContainer - here the GridContainer's items aggregation is bound and
    " the Card is its template, so the same cards come out of the model
    TYPES:
      BEGIN OF ty_s_card,
        key      TYPE string,
        columns  TYPE i,
        manifest TYPE string,
        datamode TYPE string,
      END OF ty_s_card,
      ty_t_card TYPE STANDARD TABLE OF ty_s_card WITH EMPTY KEY.
    DATA t_cards TYPE ty_t_card.

    " the form fields the controller reads on submit
    DATA numberofcards   TYPE string.
    DATA datamode_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS cards_build.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_342 IMPLEMENTATION.

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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the sample's SimpleForm (request time, number of cards, dataMode, Start
    " loading) and the f:GridContainer the controller fills with Cards - bound
    " to the model here, with the Card as the aggregation template
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:w`    v = `sap.ui.integration.widgets`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `height`     v = `100%`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable` v = `true`
            )->a( n = `width`    v = `40rem`

            )->tag( `Label`
                )->a( n = `text` v = `Time for requesting the card data`
            )->tag( `Input`
                )->a( n = `id`          v = `loadingSeconds`
                )->a( n = `width`       v = `8rem`
                )->a( n = `type`        v = `Number`
                )->a( n = `description` v = `seconds`
            )->tag( `Label`
                )->a( n = `text` v = `Number of cards`
            )->tag( `Input`
                )->a( n = `id`    v = `numberOfCards`
                )->a( n = `width` v = `4rem`
                )->a( n = `type`  v = `Number`
                )->a( n = `value` v = client->_bind( numberofcards )
            )->tag( `Label`
                )->a( n = `text` v = `dataMode to 'Active'`
            )->tag( `CheckBox`
                )->a( n = `id`       v = `dataMode`
                )->a( n = `selected` v = client->_bind( datamode_active )
            )->tag( `Button`
                )->a( n = `text`  v = `Start loading`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `FORM_SUBMIT` )

        )->end(

        )->ele( n = `GridContainer` ns = `f`
            )->a( n = `id`    v = `cardsContainer`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->a( n = `items` v = client->_bind( t_cards )

            )->ele( n = `Card` ns = `w`
                )->a( n = `manifest` v = `{MANIFEST}`
                )->a( n = `dataMode` v = `{DATAMODE}`

                )->ele( n = `layoutData` ns = `w`
                    )->tag( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `{COLUMNS}`
                        )->a( n = `minRows` v = `4` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `FORM_SUBMIT`.
        cards_build( ).

    ENDCASE.

  ENDMETHOD.


  METHOD cards_build.

    " the controller's aSamples array - ten manifests with the grid width each
    " card gets. Kept local: it is never bound, so it does not belong in the
    " model that travels on every round-trip
    DATA(lt_samples) = VALUE ty_t_card(
        ( key = `list1`       columns = 6 manifest = `listManifest1.json` )
        ( key = `list2`       columns = 6 manifest = `listManifest2.json` )
        ( key = `list3`       columns = 5 manifest = `listManifestAll.json` )
        ( key = `list4`       columns = 4 manifest = `listManifestDescriptionTitle.json` )
        ( key = `list5`       columns = 3 manifest = `listManifestIconTitle.json` )
        ( key = `table1`      columns = 4 manifest = `tableManifest.json` )
        ( key = `object1`     columns = 6 manifest = `objectManifest.json` )
        ( key = `calendar1`   columns = 5 manifest = `calendarManifest1.json` )
        ( key = `timeline1`   columns = 5 manifest = `timelineManifest.json` )
        ( key = `analytical1` columns = 5 manifest = `analyticalManifest.json` ) ).

    " the manifests are loaded BY URL: sap.ui.integration.widgets.Card reads a
    " string manifest as a manifest URL (Card.createManifest), so pointing at
    " the sample's own manifest files is the 1:1 form here
    DATA(lv_base) = `https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/LazyLoading/manifests/`.

    t_cards = VALUE #( ).
    DATA(lv_count) = COND i( WHEN numberofcards CO ` 0123456789` AND numberofcards IS NOT INITIAL
                             THEN CONV i( numberofcards ) ).

    DO lv_count TIMES.
      DATA(ls_sample) = lt_samples[ ( sy-index - 1 ) MOD lines( lt_samples ) + 1 ].
      INSERT VALUE #( key      = ls_sample-key
                      columns  = ls_sample-columns
                      manifest = lv_base && ls_sample-manifest
                      datamode = COND #( WHEN datamode_active = abap_true THEN `Active` ELSE `Auto` ) )
             INTO TABLE t_cards.
    ENDDO.

  ENDMETHOD.


  METHOD model_init.

    " the sample's form defaults: the number-of-cards Input starts at 10 and
    " the dataMode CheckBox is selected; the GridContainer starts EMPTY and is
    " only filled by the "Start loading" press, exactly like the original
    numberofcards   = `10`.
    datamode_active = abap_true.

  ENDMETHOD.

ENDCLASS.
