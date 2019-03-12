import React from "react";
import { render } from "react-dom";
import { Provider } from "react-redux";
import { BrowserRouter, Redirect, Route, Switch } from "react-router-dom";
import { ConnectedRouter } from "connected-react-router";
import { store, history } from "./store.js";
import App from "./containers/app.js";
import LoginPage from "./components/loginPage.js";
import SignupPage from "./components/signupPage.js";

const loginPageOrRedirect = () => {
  if ( store.getState().user.id ) {
    return <Redirect to="/" />
  } else {
    return <LoginPage />
  }
}

const signupPageOrRedirect = () => {
  if ( store.getState().user.id ) {
    return <Redirect to="/" />
  } else {
    return <SignupPage />
  }
}

render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Switch>
        <Route exact path="/" render={() => <App />} />
        <Route path="/login" render={loginPageOrRedirect} />
        <Route path="/signup" render={signupPageOrRedirect} />
      </Switch>
    </ConnectedRouter>
  </Provider>,
  document.getElementById("app")
);
