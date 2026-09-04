" @keywords card sap.ui.integration.widgets lazyloading simpleform label input checkbox button gridcontainer gridcontaineritemlayoutdata
" @summary dataMode:'Auto' activates lazy loading behavior of an integration card
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
      ty_t_card TYPE STANDARD TABLE OF ty_s_card WITH DEFAULT KEY.
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

    IF client->get_event( ) = `FORM_SUBMIT`.
      cards_build( ).
    ENDIF.

  ENDMETHOD.


  METHOD cards_build.

    " the controller's aSamples array - ten manifests with the grid width each
    " card gets. Kept local: it is never bound, so it does not belong in the
    " model that travels on every round-trip
    DATA temp1 TYPE ty_t_card.
    DATA temp2 LIKE LINE OF temp1.
    DATA lt_samples LIKE temp1.
    DATA lv_base TYPE string.
    DATA temp3 TYPE z2ui5_cl_smpc_app_342=>ty_t_card.
    DATA temp4 TYPE i.
    DATA temp6 TYPE i.
    DATA lv_count LIKE temp6.
      DATA ls_sample LIKE LINE OF lt_samples.
      DATA temp7 LIKE LINE OF lt_samples.
      DATA temp8 LIKE sy-tabix.
      DATA temp5 TYPE z2ui5_cl_smpc_app_342=>ty_s_card.
      DATA temp9 TYPE z2ui5_cl_smpc_app_342=>ty_s_card-datamode.
    CLEAR temp1.
    
    temp2-key = `list1`.
    temp2-columns = 6.
    temp2-manifest = `listManifest1.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `list2`.
    temp2-columns = 6.
    temp2-manifest = `listManifest2.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `list3`.
    temp2-columns = 5.
    temp2-manifest = `listManifestAll.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `list4`.
    temp2-columns = 4.
    temp2-manifest = `listManifestDescriptionTitle.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `list5`.
    temp2-columns = 3.
    temp2-manifest = `listManifestIconTitle.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `table1`.
    temp2-columns = 4.
    temp2-manifest = `tableManifest.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `object1`.
    temp2-columns = 6.
    temp2-manifest = `objectManifest.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `calendar1`.
    temp2-columns = 5.
    temp2-manifest = `calendarManifest1.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `timeline1`.
    temp2-columns = 5.
    temp2-manifest = `timelineManifest.json`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `analytical1`.
    temp2-columns = 5.
    temp2-manifest = `analyticalManifest.json`.
    INSERT temp2 INTO TABLE temp1.
    
    lt_samples = temp1.

    " the manifests are loaded BY URL: sap.ui.integration.widgets.Card reads a
    " string manifest as a manifest URL (Card.createManifest), so pointing at
    " the sample's own manifest files is the 1:1 form here
    
    lv_base = `https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/LazyLoading/manifests/`.

    
    CLEAR temp3.
    t_cards = temp3.
    " the length term, not just the character one - `99999999999` is all
    " digits and overflows CONV i
    
    temp4 = numberofcards.
    
    IF numberofcards CO ` 0123456789` AND numberofcards IS NOT INITIAL AND strlen( condense( numberofcards ) ) <= 9.
      temp6 = temp4.
    ELSE.
      CLEAR temp6.
    ENDIF.
    
    lv_count = temp6.

    DO lv_count TIMES.
      
      
      
      temp8 = sy-tabix.
      READ TABLE lt_samples INDEX ( sy-index - 1 ) MOD lines( lt_samples ) + 1 INTO temp7.
      sy-tabix = temp8.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      ls_sample = temp7.
      
      CLEAR temp5.
      temp5-key = ls_sample-key.
      temp5-columns = ls_sample-columns.
      temp5-manifest = lv_base && ls_sample-manifest.
      
      IF datamode_active = abap_true.
        temp9 = `Active`.
      ELSE.
        temp9 = `Auto`.
      ENDIF.
      temp5-datamode = temp9.
      INSERT temp5
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
