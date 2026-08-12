CLASS z2ui5_cl_dmo_app_341 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " manifests/cardManifests.json, one field per Card the view binds. The
    " original carries them in a named `manifests>` model the controller pushes
    " into the Cards on submit; abap2UI5 has one default model, so each manifest
    " is a bound field - the JSON literal `null` until "Start loading" is
    " pressed, which is how a manifest-less Card reaches the client here
    CONSTANTS c_no_manifest TYPE string VALUE `null`.
    DATA manifest_listtest         TYPE string.
    DATA manifest_list             TYPE string.
    DATA manifest_error            TYPE string.
    DATA manifest_all              TYPE string.
    DATA manifest_descriptiontitle TYPE string.
    DATA manifest_icontitle        TYPE string.
    DATA manifest_table            TYPE string.
    DATA manifest_analytical       TYPE string.
    DATA manifest_calendar         TYPE string.
    DATA manifest_object           TYPE string.
    DATA manifest_timeline         TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_341 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " no model_init here: the sample's Cards start WITHOUT a manifest and are
      " filled by the "Start loading" press - so the model is seeded there.
      " The eleven fields still have to carry the JSON literal `null` rather
      " than stay empty: their bind splices the string into the model as a JSON
      " NODE (_bind( json = abap_true )), and an empty string is not JSON - it
      " raises. `null` IS, and a null manifest is exactly the manifest-less
      " Card the original renders before its first onFormSubmit
      manifest_listtest         = c_no_manifest.
      manifest_list             = c_no_manifest.
      manifest_error            = c_no_manifest.
      manifest_all              = c_no_manifest.
      manifest_descriptiontitle = c_no_manifest.
      manifest_icontitle        = c_no_manifest.
      manifest_table            = c_no_manifest.
      manifest_analytical       = c_no_manifest.
      manifest_calendar         = c_no_manifest.
      manifest_object           = c_no_manifest.
      manifest_timeline         = c_no_manifest.
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the sample's SimpleForm (loading time + Start loading) and the
    " f:GridContainer with the eleven sap.ui.integration Cards, each rendering
    " from its own declarative JSON manifest carried as a bound ABAP string
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:w`    v = `sap.ui.integration.widgets`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `height`     v = `100%`

        )->open( n = `SimpleForm` ns = `form`
            )->a( n = `editable` v = `true`
            )->a( n = `width`    v = `40rem`

            )->leaf( `Label`
                )->a( n = `text` v = `Loading time`
            )->leaf( `Input`
                )->a( n = `id`          v = `loadingMinSeconds`
                )->a( n = `width`       v = `8rem`
                )->a( n = `type`        v = `Number`
                )->a( n = `description` v = `seconds`
                )->a( n = `value`       v = `-1`
            )->leaf( `Button`
                )->a( n = `text`  v = `Start loading`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `FORM_SUBMIT` )

        )->shut(

        )->open( n = `GridContainer` ns = `f`
            )->a( n = `id`    v = `grd`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `listTest`
                )->a( n = `manifest` v = client->_bind( val = manifest_listtest json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `4`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `list`
                )->a( n = `manifest` v = client->_bind( val = manifest_list json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `3`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `error`
                )->a( n = `manifest` v = client->_bind( val = manifest_error json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `4`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `all`
                )->a( n = `manifest` v = client->_bind( val = manifest_all json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `4`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `descriptionTitle`
                )->a( n = `manifest` v = client->_bind( val = manifest_descriptiontitle json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `3`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `iconTitle`
                )->a( n = `manifest` v = client->_bind( val = manifest_icontitle json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `4`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `table`
                )->a( n = `manifest` v = client->_bind( val = manifest_table json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `5`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `analytical`
                )->a( n = `manifest` v = client->_bind( val = manifest_analytical json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `6`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `calendar`
                )->a( n = `manifest` v = client->_bind( val = manifest_calendar json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `4`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `object`
                )->a( n = `manifest` v = client->_bind( val = manifest_object json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `5`

                )->shut(
            )->shut(

            )->open( n = `Card` ns = `w`
                )->a( n = `id`       v = `timeline`
                )->a( n = `manifest` v = client->_bind( val = manifest_timeline json = abap_true )

                )->open( n = `layoutData` ns = `w`
                    )->leaf( n = `GridContainerItemLayoutData` ns = `f`
                        )->a( n = `columns` v = `3`

                )->shut(
            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `FORM_SUBMIT`.
        " the original walks the grid items and either sets the manifest (first
        " press) or refreshes an already-loaded Card. Same split here: the first
        " press publishes the manifests through the model, every later press
        " calls refresh( ) on each Card via a frontend action
        IF manifest_listtest = c_no_manifest.
          model_init( ).
          client->view_model_update( ).
        ELSE.
          LOOP AT VALUE string_table( ( `listTest` ) ( `list` ) ( `error` ) ( `all` )
                                      ( `descriptionTitle` ) ( `iconTitle` ) ( `table` )
                                      ( `analytical` ) ( `calendar` ) ( `object` )
                                      ( `timeline` ) ) INTO DATA(lv_card_id).
            client->follow_up_action( val   = client->cs_event-control_by_id
                                      t_arg = VALUE #( ( lv_card_id ) ( `refresh` ) ) ).
          ENDLOOP.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " manifests/cardManifests.json verbatim; the relative data request URLs are
    " absolutized to the OpenUI5 host (the original resolves them through
    " sap.ui.require.toUrl in its sinon stub, which has no server-side
    " equivalent). Called from on_event, not from main - the Cards stay
    " manifest-less until "Start loading" is pressed, like the original
    manifest_listtest = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"List","header":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/mani` &&
                        `fests/listData1.json"},"path":"/header"},"title":"{title}","subtitle":"{subtitle}","icon":{"src":"sap-icon://newspaper"}},"content":{"maxItems":3,` &&
                        `"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/listData1.json"},"path":"/content"},` &&
                        `"item":{"title":{"label":"{{title_label}}","value":"{Name}"},"icon":{"src":"{icon}"},"highlight":"{state}","info":{"value":"{info}","state":"{infoState}"}}}}}`.

    manifest_list = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"List","header":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/mani` &&
                    `fests/listData2.json"},"path":"/header"},"title":"{title}","subtitle":"Subtitle","status":{"text":"2 of {count}"},"icon":{"src":"{src}"}},"content":{"maxItems":8,` &&
                    `"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/someitems.json"}},"item":{"title":{"label":"{{title_label}}",` &&
                    `"value":"{Name}"},"highlight":"{state}","info":{"value":"{info}","state":"{infoState}"}}}}}`.

    manifest_error = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"List","header":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/mani` &&
                     `fests/listData2.json"},"path":"/header"},"title":"Error Test Case ","subtitle":"Unable to fetch data","icon":{"src":"{src}"}},` &&
                     `"content":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/listDat2.json"},"path":"/content"},` &&
                     `"item":{"title":{"label":"{{title_label}}","value":"{Name}"},"icon":{"src":"{icon}"},"description":{"value":"{Name}"}}}}}`.

    manifest_all = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"List","header":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/mani` &&
                   `fests/listData2.json"},"path":"/header"},"title":"{title}","subtitle":"Subtitle","status":{"text":"3 of {count}"},"icon":{"src":"{src}"}},` &&
                   `"content":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/listData2.json"},"path":"/content"},` &&
                   `"item":{"title":{"label":"{{title_label}}","value":"{Name}"},"icon":{"src":"{icon}"},"description":{"value":"{Name}"}}}}}`.

    manifest_descriptiontitle = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"List","header":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/mani` &&
                                `fests/listData2.json"},"path":"/header"},"title":"{title}","subtitle":"Subtitle","status":{"text":"3 of {count}"},"icon":{"src":"{src}"}},"content":{"maxItems":8,` &&
                                `"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/someitems.json"}},"item":{"title":{"label":"{{title_label}}",` &&
                                `"value":"{Name}"},"description":{"value":"{Name}"}}}}}`.

    manifest_icontitle = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"List","header":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/mani` &&
                         `fests/listData2.json"},"path":"/header"},"title":"{title}","subtitle":"Subtitle","status":{"text":"2 of {count}"},"icon":{"src":"{src}"}},` &&
                         `"content":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/listData2.json"},"path":"/content"},` &&
                         `"item":{"title":{"label":"{{title_label}}","value":"{Name}"},"icon":{"src":"{icon}"}}}}}`.

    manifest_table = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/tableData.json"}},` &&
                     `"type":"Table","header":{"type":"Numeric","data":{"path":"/header"},"title":"Table Card ","subtitle":"{revenue}","unitOfMeasurement":"EUR","mainIndicator":{"number":"{number}","unit":"{unit}",` &&
                     `"trend":"{trend}","state":"{state}"},"details":"{details}","sideIndicators":[{"title":"Target","number":"{target/number}","unit":"{target/unit}"},{"title":"Deviation","number":"{deviation/number}",` &&
                     `"unit":"%"}],"status":{"text":"9 of {count}"}},"content":{"data":{"path":"/content"},"maxItems":9,"row":{"columns":[{"title":"Sales Order","value":"{salesOrder}","identifier":true},` &&
                     `{"title":"Customer","value":"{name}"},{"title":"Net Amount","value":"{netAmount}"},{"title":"Status","value":"{status}","state":"{statusState}"}]}}}}`.

    manifest_analytical = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"Analytical","header":{"type":"Numeric",` &&
                          `"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/analyticalData.json"},"path":"/header"},"title":"{details}",` &&
                          `"subtitle":"Analytical Card","unitOfMeasurement":"EUR","mainIndicator":{"number":"{number}","unit":"{unit}","trend":"{trend}","state":"{state}"},"details":"{details}",` &&
                          `"sideIndicators":[{"title":"Target","number":"{target/number}","unit":"{target/unit}"},{"title":"Deviation","number":"{deviation/number}","unit":"%"}]},"content":{"chartType":"Line",` &&
                          `"legend":{"visible":"{legend/visible}","position":"{legend/position}","alignment":"{legend/alignment}"},"plotArea":{"dataLabel":{"visible":true},"categoryAxisText":{"visible":false},` &&
                          `"valueAxisText":{"visible":false}},"title":{"text":"Line chart","visible":true,"alignment":"Left"},"measureAxis":"valueAxis","dimensionAxis":"categoryAxis",` &&
                          `"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/analyticalData.json"},"path":"/list"},` &&
                          `"dimensions":[{"label":"{dimensions/weekLabel}","value":"{Week}"}],"measures":[{"label":"{measures/revenueLabel}","value":"{Revenue}"},{"label":"{measures/costLabel}","value":"{Cost}"}]}}}`.

    manifest_calendar = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"Calendar","data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/` &&
                        `calendarData.json"}},"header":{"title":"My calendar","subtitle":"Team Balkan","status":{"text":{"format":{"translationKey":"i18n>CARD.COUNT_X_OF_Y","parts":["parameters>/visibleItems",` &&
                        `"parameters>/allItems"]}}}},"content":{"date":"2019-9-2","maxItems":5,"maxLegendItems":3,"noItemsText":"You have nothing planned for that day","item":{"template":{"visualization":"{visualization}",` &&
                        `"startDate":"{start}","endDate":"{end}","title":"{title}","text":"{text}","icon":{"src":"{icon}"},"type":"{type}"},"path":"/item"},"specialDate":{"template":{"startDate":"{start}","endDate":"{end}",` &&
                        `"type":"{type}"},"path":"/specialDate"},"legendItem":{"template":{"category":"{category}","text":"{text}","type":"{type}"},"path":"/legendItem"},"moreItems":{"actions":[{"type":"Navigation",` &&
                        `"enabled":true,"url":"http://sap.com"}]}}}}`.

    manifest_object = `{"_version":"1.81.0","sap.app":{"type":"card"},"sap.card":{"type":"Object","data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/manifests/em` &&
                      `ployee.json"}},"header":{"icon":{"src":"{photo}"},"title":"Object Card","subtitle":"{position}"},"content":{"groups":[{"title":"Contact Details","items":[{"label":"First Name","value":"{firstName}"},` &&
                      `{"label":"Last Name","value":"{lastName}"},{"label":"Phone","value":"{phone}","actions":[{"type":"Navigation","parameters":{"url":"tel:{phone}"}}]}]},{"title":"Organizational Details",` &&
                      `"items":[{"label":"Direct manager","value":"{manager/firstName} {manager/lastName}","icon":{"src":"{manager/photo}"}}]},{"title":"Company Details","items":[{"label":"Company Name",` &&
                      `"value":"{company/name}"},{"label":"{address}","value":"{company/address}"},{"label":"{website}","value":"{company/website}","actions":[{"type":"Navigation",` &&
                      `"parameters":{"url":"{company/website}"}}]}]}]}}}`.

    manifest_timeline = `{"_version":"1.15.0","sap.app":{"id":"card.explorer.members.timeline.card","type":"card","title":"Sample of a Members Timeline","subTitle":"Sample of a Members Timeline",` &&
                        `"applicationVersion":{"version":"1.0.0"},"shortTitle":"A short title for this Card","info":"Additional information about this Card","description":"A long description for this Card",` &&
                        `"tags":{"keywords":["Timeline","Card","Sample"]}},"sap.ui":{"technology":"UI5","icons":{"icon":"sap-icon://activity-individual"}},"sap.card":{"_version":"1.81.0","type":"Timeline",` &&
                        `"header":{"title":"New Team Members","icon":{"src":"sap-icon://group"}},"content":{"data":{"request":{"url":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLoading/mani` &&
                        `fests/timelineData.json"}},"item":{"dateTime":{"value":"{HireDate}"},"description":{"value":"{JobResponsibilities}"},"title":{"value":"{JobTitle}"},"owner":{"value":"{Name}"},` &&
                        `"ownerImage":{"value":"{Photo}"},"icon":{"src":"{Icon}"}}}}}`.

  ENDMETHOD.

ENDCLASS.
