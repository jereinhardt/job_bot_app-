import React from "react";
import { render } from "react-dom";
import { Provider } from "react-redux";
import { BrowserRouter, Redirect, Route, Switch } from "react-router-dom";
import { ConnectedRouter } from "connected-react-router";
import { store, history } from "./store.js";
import { loginPath, mainAppPath, resultsPath, rootPath, signupPath } from "./routes.js";
import App from "./containers/app.js";
import LandingPage from "./components/landingPage.js";
import LoginPage from "./components/loginPage.js";
import ResultsPage from "./components/resultsPage.js";
import SignupPage from "./components/signupPage.js";

const componentOrRedirect = (component) => {
  if ( store.getState().user.id ) {
    return <Redirect to={mainAppPath} />
  } else {
    return component
  }
}

const landingPage = componentOrRedirect(<LandingPage />)
const loginPage = componentOrRedirect(<LoginPage />)
const signupPage = componentOrRedirect(<SignupPage />)
const resultsPage = componentOrRedirect(<ResultsPage />)

render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Switch>
        <Route exact path={mainAppPath} render={() => <App />} />
        <Route exact path={resultsPath} render={() => resultsPage} />
        <Route exact path={rootPath} render={() => landingPage} />
        <Route exact path={loginPath} render={() => loginPage} />
        <Route exact path={signupPath} render={() => signupPage} />
      </Switch>
    </ConnectedRouter>
  </Provider>,
  document.getElementById("app")
);
