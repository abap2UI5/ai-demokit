CLASS z2ui5_cl_smpc_app_118 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " model/cardManifests.json, one field per manifest the view binds. The
    " original carries them in a named `manifests>` model and binds
    " {manifests>/timeline}; folded to the one default model, the last path
    " segment stays identical, which is what structural-diff matches.
    DATA manifest_timeline      TYPE string.
    DATA manifest_object        TYPE string.
    DATA manifest_component     TYPE string.
    DATA manifest_calendar      TYPE string.
    DATA manifest_stackedcolumn TYPE string.
    DATA manifest_donut         TYPE string.
    DATA manifest_list1         TYPE string.
    DATA manifest_list2         TYPE string.

    " the sample's plain JSON model, which the ShellBar binds
    DATA homeiconurl TYPE string.
    DATA date        TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_118 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the full sample: the f:ShellBar, the four-tab IconTabBar and the two
    " f:GridContainers with all EIGHT integration Cards, each rendering from
    " its own declarative JSON manifest carried as a bound ABAP string
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:card` v = `sap.f.cards`
        )->a( n = `xmlns:w`    v = `sap.ui.integration.widgets`
        )->a( n = `height`     v = `100%`

        )->ele( n = `ShellBar` ns = `f`
            )->a( n = `title`               v = `Drone Hive`
            )->a( n = `secondTitle`         v = client->_bind( date )
            )->a( n = `homeIcon`            v = client->_bind( homeiconurl )
            )->a( n = `showCopilot`         v = `true`
            )->a( n = `showSearch`          v = `true`
            )->a( n = `showNotifications`   v = `true`
            )->a( n = `showProductSwitcher` v = `true`
            )->a( n = `notificationsNumber` v = `2`
            )->a( n = `class`               v = `sapUiSmallMarginTop sapUiSmallMarginBegin`

            )->ele( n = `menu` ns = `f`
                )->ele( `Menu`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Drone Hive`
                        )->a( n = `icon` v = client->_bind( homeiconurl )

                )->end(
            )->end(
            )->ele( n = `profile` ns = `f`
                )->tag( `Avatar`
                    )->a( n = `initials` v = `UI`

            )->end(
        )->end(

        )->ele( `IconTabBar`
            )->a( n = `id`                     v = `idIconTabBar`
            )->a( n = `headerBackgroundDesign` v = `Transparent`
            )->a( n = `class`                  v = `sapUiResponsiveContentPadding sapUiSmallMarginBegin`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `text` v = `Home`

                    )->ele( n = `GridContainer` ns = `f`
                        )->ele( n = `layout` ns = `f`
                            )->tag( n = `GridContainerSettings` ns = `f`
                                )->a( n = `rowSize`    v = `5rem`
                                )->a( n = `columnSize` v = `5rem`
                                )->a( n = `gap`        v = `1rem`

                        )->end(
                        )->ele( n = `layoutS` ns = `f`
                            )->tag( n = `GridContainerSettings` ns = `f`
                                )->a( n = `rowSize`    v = `5rem`
                                )->a( n = `columnSize` v = `5rem`
                                )->a( n = `gap`        v = `0.5rem`

                        )->end(

                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( val = manifest_timeline json = abap_true )
                            " onAction toasts the navigation URL off the event - it
                            " resolves on the client, so the action needs no roundtrip
                            )->a( n = `action`   v = client->follow_up_action(
                                      val   = client->cs_event-control_global
                                      t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                       ( `show` )
                                                       ( `URL: {0}` )
                                                       ( `${$parameters>/parameters}.url` ) ) )

                            )->ele( n = `customData` ns = `w`
                                )->tag( n = `CardBadgeCustomData` ns = `card`
                                    )->a( n = `value` v = `Updated`
                                    )->a( n = `icon` v = `sap-icon://status-in-process`
                                    )->a( n = `state` v = `Indication03`
                                    )->a( n = `announcementText` v = `The card is recently updated.`

                            )->end(

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `4`
                                    )->a( n = `columns` v = `4`

                            )->end(
                        )->end(
                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( val = manifest_object json = abap_true )
                            " onAction toasts the navigation URL off the event - it
                            " resolves on the client, so the action needs no roundtrip
                            )->a( n = `action`   v = client->follow_up_action(
                                      val   = client->cs_event-control_global
                                      t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                       ( `show` )
                                                       ( `URL: {0}` )
                                                       ( `${$parameters>/parameters}.url` ) ) )

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `4`
                                    )->a( n = `columns` v = `3`

                            )->end(
                        )->end(
                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( manifest_component )
                            " onAction toasts the navigation URL off the event - it
                            " resolves on the client, so the action needs no roundtrip
                            )->a( n = `action`   v = client->follow_up_action(
                                      val   = client->cs_event-control_global
                                      t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                       ( `show` )
                                                       ( `URL: {0}` )
                                                       ( `${$parameters>/parameters}.url` ) ) )

                            )->ele( n = `customData` ns = `w`
                                )->tag( n = `CardBadgeCustomData` ns = `card`
                                    )->a( n = `value` v = `New`
                                    )->a( n = `announcementText` v = `Card was newly added.`
                                )->tag( n = `CardBadgeCustomData` ns = `card`
                                    )->a( n = `icon` v = `sap-icon://pushpin-off`
                                    )->a( n = `visibilityMode` v = `Persist`
                                    )->a( n = `announcementText` v = `The card is pinned on top.`

                            )->end(

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `5`
                                    )->a( n = `columns` v = `6`

                            )->end(
                        )->end(
                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( val = manifest_calendar json = abap_true )
                            " onAction toasts the navigation URL off the event - it
                            " resolves on the client, so the action needs no roundtrip
                            )->a( n = `action`   v = client->follow_up_action(
                                      val   = client->cs_event-control_global
                                      t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                       ( `show` )
                                                       ( `URL: {0}` )
                                                       ( `${$parameters>/parameters}.url` ) ) )

                            )->ele( n = `customData` ns = `w`
                                )->tag( n = `CardBadgeCustomData` ns = `card`
                                    )->a( n = `value` v = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum congue libero ut blandit faucibus. Phasellus sed urna id tortor consequat accumsan eget at leo. Cras quis arcu magna.`
                                    )->a( n = `announcementText` v = `Lorem ipsum`

                            )->end(

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `4`
                                    )->a( n = `columns` v = `4`

                            )->end(
                        )->end(
                    )->end(
                    )->tag( `Title`
                        )->a( n = `text`       v = `Incidents`
                        )->a( n = `titleStyle` v = `H2`
                        )->a( n = `class`      v = `sapUiSmallMarginBottom sapUiSmallMarginTop sapUiSmallMarginBegin`
                    )->ele( n = `GridContainer` ns = `f`
                        )->ele( n = `layout` ns = `f`
                            )->tag( n = `GridContainerSettings` ns = `f`
                                )->a( n = `rowSize`    v = `5rem`
                                )->a( n = `columnSize` v = `5rem`
                                )->a( n = `gap`        v = `1rem`

                        )->end(
                        )->ele( n = `layoutS` ns = `f`
                            )->tag( n = `GridContainerSettings` ns = `f`
                                )->a( n = `rowSize`    v = `5rem`
                                )->a( n = `columnSize` v = `5rem`
                                )->a( n = `gap`        v = `0.5rem`

                        )->end(

                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( val = manifest_stackedcolumn json = abap_true )

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `rows` v = `5`
                                    )->a( n = `columns` v = `4`

                            )->end(
                        )->end(
                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( val = manifest_donut json = abap_true )

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `rows` v = `4`
                                    )->a( n = `columns` v = `4`

                            )->end(
                        )->end(
                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( val = manifest_list1 json = abap_true )
                            )->a( n = `baseUrl`  v = `./`

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `columns` v = `4`

                            )->end(
                        )->end(
                        )->ele( n = `Card` ns = `w`
                            )->a( n = `manifest` v = client->_bind( val = manifest_list2 json = abap_true )
                            )->a( n = `baseUrl`  v = `./`
                            " onAction toasts the navigation URL off the event - it
                            " resolves on the client, so the action needs no roundtrip
                            )->a( n = `action`   v = client->follow_up_action(
                                      val   = client->cs_event-control_global
                                      t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                       ( `show` )
                                                       ( `URL: {0}` )
                                                       ( `${$parameters>/parameters}.url` ) ) )

                            )->ele( n = `layoutData` ns = `w`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `columns` v = `4`

                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->tag( `IconTabFilter`
                    )->a( n = `text` v = `Team Distribution`
                )->tag( `IconTabFilter`
                    )->a( n = `text` v = `Drone Maintenance`
                )->tag( `IconTabFilter`
                    )->a( n = `text` v = `Drone Development` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the sample's own JSON model: the company logo and today's date. The date
    " is a MOVING value (DateFormat over UI5Date.getInstance()), so it is
    " anchored on a fixed one here - the corpus rule for now/random values
    homeiconurl = `https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/CompanyLogo.png`.
    date        = `August 6, 2026`.

    " the component card's manifest is a URL, not an inline object: the
    " original resolves it with a formatter (.resolveCardUrl) against the
    " sample folder. Computed in ABAP instead (thin-frontend rule)
    manifest_component = `https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/componentCard/manifest.json`.

    " model/cardManifests.json, the seven inline manifests verbatim (asset URLs
    " absolutized to the OpenUI5 host per the asset-URL rule)
    manifest_timeline = `{"_version":"1.81.0","sap.app":{"id":"sample.CardsLayout.model.timeline","type":"card"},"sap.card":{"type":"Timeline","header":{"title":"Schedule for today","subtitle":"9:32 AM","status":{"text":"3 of 3"}` &&
                         `,"actions":[{"type":"Navigation","parameters":{"url":"/quickLinks"}}]},"content":{"data":{"json":[{"Title":"Call Donna Mendez","Icon":"sap-icon://outgoing-call","Time":"9:15 AM"}` &&
                         `,{"Title":"Incidents Status - Online","Icon":"sap-icon://my-view","Time":"10:00 - 11:00"},{"Title":"Site Visit - Peach Valley","Description":"San Joaquin valley","Icon":"sap-icon://appointment-2","Time":` &&
                         `"12:00 - 17:00"}]},"item":{"dateTime":{"value":"{Time}"},"description":{"value":"{Description}"},"title":{"value":"{Title}"}` &&
                         `,"icon":{"src":"{Icon}"}}}}}`.

    manifest_object = `{"_version":"1.81.0","sap.app":{"id":"sample.CardsLayout.model.object","type":"card"},"sap.card":{"type":"Object","actions":[{"type":"Navigation","parameters":{"url":"users/donnaMendez"}` &&
                       `}],"data":{"json":{"firstName":"Donna","lastName":"Mendez","position":"Managing Partner","mobile":"+1 202 34869-0","phone":"+1 202 555 5555","email":"donna@peachvalley.com"}` &&
                       `},"header":{"icon":{"text":"DM"},"title":"{firstName} {lastName}","subtitle":"{position}"},"content":{"groups":[{"title":"Peach Valley Inc.","items":[{"label":"Mobile","value":"{mobile}","actions":[{"type":` &&
                       `"Navigation","parameters":{"url":"tel:{mobile}"}}]},{"label":"Phone","value":"{phone}","actions":[{"type":"Navigation","parameters":{"url":"tel:{phone}"}` &&
                       `}]},{"label":"Email","value":"{email}","actions":[{"type":"Navigation","parameters":{"url":"mailto:{email}"}}]}]}]}}}`.

    manifest_calendar = `{"_version":"1.81.0","sap.app":{"id":"sample.CardsLayout.model.calendar","type":"card"},"sap.card":{"type":"Calendar","data":{"json":{"item":[{"visualization":"blocker","start":"2019-09-02T09:00","end":` &&
                         `"2019-09-02T10:00","title":"Payment reminder","icon":"sap-icon://desktop-mobile","type":"Type06"},{"visualization":"blocker","start":"2019-09-02T17:00","end":"2019-09-02T17:30","title":"Private appointment",` &&
                         `"icon":"sap-icon://desktop-mobile","type":"Type07"},{"visualization":"appointment","start":"2019-09-02T12:00","end":"2019-09-02T13:00","title":"Lunch","text":"working","icon":"sap-icon://desktop-mobile",` &&
                         `"type":"Type03"},{"visualization":"appointment","start":"2019-09-01T08:30","end":"2019-09-03T17:30","title":"Workshop","text":"Out of office","icon":"sap-icon://sap-ui5","type":"Type07"}` &&
                         `,{"visualization":"appointment","start":"2019-09-02T14:00","end":"2019-09-02T16:30","title":"Discussion with clients","text":"working","icon":"sap-icon://desktop-mobile"}` &&
                         `,{"visualization":"appointment","start":"2019-09-02T11:00","end":"2019-09-02T12:00","title":"Team meeting","text":"online meeting","icon":"sap-icon://sap-ui5","type":"Type04"}` &&
                         `,{"visualization":"blocker","start":"2019-09-03T17:00","end":"2019-09-03T17:30","title":"Private appointment","icon":"sap-icon://desktop-mobile","type":"Type07"}` &&
                         `,{"visualization":"appointment","start":"2019-09-03T12:00","end":"2019-09-03T13:00","title":"Lunch","text":"working","icon":"sap-icon://desktop-mobile","type":"Type03"}` &&
                         `,{"visualization":"appointment","start":"2019-09-03T10:00","end":"2019-09-03T12:30","title":"Board meeting","icon":"sap-icon://desktop-mobile"}` &&
                         `,{"visualization":"appointment","start":"2019-09-04T12:00","end":"2019-09-04T13:00","title":"Lunch","text":"working","icon":"sap-icon://desktop-mobile","type":"Type03"}` &&
                         `,{"visualization":"blocker","start":"2019-09-04T17:00","end":"2019-09-04T17:30","title":"Private appointment","icon":"sap-icon://desktop-mobile","type":"Type07"}` &&
                         `,{"visualization":"appointment","start":"2019-09-05T11:00","end":"2019-09-05T12:00","title":"Team meeting","text":"online meeting","icon":"sap-icon://sap-ui5","type":"Type04"}` &&
                         `,{"visualization":"blocker","start":"2019-09-06T09:00","end":"2019-09-06T10:00","title":"Payment reminder","icon":"sap-icon://desktop-mobile","type":"Type06"}` &&
                         `],"specialDate":[{"start":"2019-09-13","end":"2019-09-14","type":"Type08"},{"start":"2019-09-24","end":"2019-09-24","type":"Type13"}` &&
                         `],"legendItem":[{"category":"calendar","text":"Team building","type":"Type08"},{"category":"calendar","text":"Public holliday","type":"Type13"}` &&
                         `,{"category":"appointment","text":"Reminder","type":"Type06"},{"category":"appointment","text":"Private appointment","type":"Type07"}` &&
                         `,{"category":"appointment","text":"Out of office","type":"Type03"},{"category":"appointment","text":"Collaboration with other team members","type":"Type07"}` &&
                         `]}},"header":{"title":"My calendar","subtitle":"Team Balkan","status":{"text":{"format":{"translationKey":"i18n>CARD.COUNT_X_OF_Y","parts":["parameters>/visibleItems","parameters>/allItems"]` &&
                         `}}}},"content":{"date":"2019-09-02","maxItems":5,"maxLegendItems":3,"noItemsText":"You have nothing planned for that day","item":{"template":{"visualization":"{visualization}","startDate":"{start}","endDate":` &&
                         `"{end}","title":"{title}","text":"{text}","icon":"{icon}","type":"{type}"},"path":"/item"},"specialDate":{"template":{"startDate":"{start}","endDate":"{end}","type":"{type}"}` &&
                         `,"path":"/specialDate"},"legendItem":{"template":{"category":"{category}","text":"{text}","type":"{type}"},"path":"/legendItem"}` &&
                         `,"moreItems":{"actions":[{"type":"Navigation","enabled":true,"url":"http://sap.com"}]}}}}`.

    manifest_stackedcolumn = `{"_version":"1.81.0","sap.app":{"id":"sample.CardsLayout.model.Analytical","type":"card"},"sap.card":{"type":"Analytical","header":{"type":"Numeric","data":{"json":{"n":"43.2","u":"%","trend":"Down","valueColor":` &&
                              `"Good"}},"title":"Failure Breakdown - Q1, 2019","mainIndicator":{"number":"{n}","unit":"{u}","trend":"{trend}","state":"{valueColor}"}` &&
                              `},"content":{"chartType":"StackedColumn","legend":{"visible":true,"position":"Bottom","alignment":"Left"},"plotArea":{"dataLabel":{"visible":false,"showTotal":false}` &&
                              `,"categoryAxisText":{"visible":false},"valueAxisText":{"visible":false}},"title":{"visible":false},"measureAxis":"valueAxis","dimensionAxis":"categoryAxis","data":{"json":{"list":[{"Category":"Weather",` &&
                              `"Revenue":431000.22,"Cost":230000.0,"Target":500000.0,"Budget":210000.0},{"Category":"Mechanics","Revenue":494000.3,"Cost":238000.0,"Target":500000.0,"Budget":224000.0}` &&
                              `,{"Category":"Software","Revenue":491000.17,"Cost":221000.0,"Target":500000.0,"Budget":238000.0}]},"path":"/list"},"dimensions":[{"label":"Categories","value":"{Category}"}` &&
                              `],"measures":[{"label":"Revenue","value":"{Revenue}"},{"label":"Cost","value":"{Cost}"},{"label":"Target","value":"{Target}"}` &&
                              `]}}}`.

    manifest_donut = `{"_version":"1.81.0","sap.app":{"id":"sample.CardsLayout.model.donut","type":"card"},"sap.card":{"type":"Analytical","header":{"title":"Weather Failures"}` &&
                      `,"content":{"chartType":"Donut","legend":{"visible":true,"position":"Bottom","alignment":"Left"},"plotArea":{"dataLabel":{"visible":true,"showTotal":true}` &&
                      `},"title":{"visible":false},"measureAxis":"size","dimensionAxis":"color","data":{"json":{"measures":[{"measureName":"Storm Wind","value":1564235.29}` &&
                      `,{"measureName":"Storm Wind","value":157913.07},{"measureName":"Rain","value":1085567.22},{"measureName":"Rain","value":245609.486884}` &&
                      `,{"measureName":"Temperature","value":345292.06},{"measureName":"Temperature","value":82922.07}]},"path":"/measures"},"dimensions":[{"label":"Measure Name","value":"{measureName}"}` &&
                      `],"measures":[{"label":"Value","value":"{value}"}]}}}`.

    manifest_list1 = `{"_version":"1.81.0","sap.app":{"id":"sample.CardsLayout.model.list","type":"card"},"sap.card":{"type":"List","header":{"title":"Incidents in the last 24 hours","status":{"text":"3 of 3"}` &&
                      `},"content":{"data":{"json":[{"name":"Teico Inc.","icon":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/Case1.png","description":"Sun Valley,` &&
                      ` Idaho","info":"2456","infoState":"Error"},{"name":"Freshhh LTD.","icon":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/Case2.png","description":"Dayville,` &&
                      ` Oregon","info":"1264","infoState":"Warning"},{"name":"Lean Pulp","icon":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/Case3.png","description":"Raymond,` &&
                      ` Callifornia","info":"236","infoState":"None"}]},"item":{"icon":{"src":"{icon}"},"title":{"value":"{name}"},"description":{"value":"{description}"}` &&
                      `,"info":{"value":"{info}","state":"{infoState}"}}}}}`.

    manifest_list2 = `{"_version":"1.81.0","sap.app":{"id":"sample.CardsLayout.model.list2","type":"card"},"sap.card":{"type":"List","header":{"title":"Incidents in the last 24 hours","subtitle":"Suddent storm wind damaged 3 polinating hives",` &&
                      `"icon":{"src":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/CompanyLogo.png"}` &&
                      `},"content":{"data":{"json":[{"name":"Alain Chevalier","icon":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/Avatar_1.png","description":"On Site"}` &&
                      `,{"name":"Yolanda Barrueco","icon":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/Avatar_2.png","description":"Travelling to Idaho"}` &&
                      `,{"name":"Arend Pellewever","icon":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/Avatar_3.png","description":"Travelling to Idaho"}` &&
                      `,{"name":"Lean Pulp","icon":"https://sdk.openui5.org/test-resources/sap/ui/integration/demokit/sample/CardsLayout/images/Avatar_4.png","description":"Headquaters Support"}` &&
                      `]},"item":{"icon":{"src":"{icon}"},"title":{"value":"{name}"},"description":{"value":"{description}"},"actions":[{"type":"Navigation","parameters":{"url":"/users/{name}"}` &&
                      `}]}}}}`.

  ENDMETHOD.

ENDCLASS.
