import React from "react";
import { render } from "react-dom";
import { Provider } from "react-redux";
import { BrowserRouter, Route, Switch } from "react-router-dom";
import { ConnectedRouter } from "connected-react-router";
import { history, initializeStore } from "./store.js";
import { loginPath, mainAppPath, resultsPath, rootPath, signupPath } from "./routes.js";
import { loggedInComponent, loggedOutComponent } from "./utils/componentRendering.js";
import App from "./containers/app.js";
import LandingPage from "./components/landingPage.js";
import LoginPage from "./components/loginPage.js";
import ResultsPage from "./components/resultsPage.js";
import SignupPage from "./components/signupPage.js";

const appContainer = document.getElementById("app");
const state = JSON.parse(appContainer.dataset.reactState);
const store = initializeStore(state);

render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Switch>
        <Route
          exact
          path={mainAppPath}
          render={() => <App />}
        />
        <Route
          exact
          path={resultsPath}
          render={() => loggedInComponent(<ResultsPage />, store)}
        />
        <Route
          exact
          path={rootPath}
          render={() => loggedOutComponent(<LandingPage />, store)}
        />
        <Route
          exact
          path={loginPath}
          render={() => loggedOutComponent(<LoginPage />, store)}
        />
        <Route
          exact
          path={signupPath}
          render={() => loggedOutComponent(<SignupPage />, store)}
        />
      </Switch>
    </ConnectedRouter>
  </Provider>,
  appContainer
);
