import React from "react";
import { render } from "react-dom";
import { Provider } from "react-redux";
import { BrowserRouter, Redirect, Route, Switch } from "react-router-dom";
import { ConnectedRouter } from "connected-react-router";
import { store, history } from "./store.js";
import App from "./containers/app.js";
import LoginForm from "./containers/loginForm.js";

const loginFormOrRedirect = () => {
  if ( store.getState().user.id ) {
    return <Redirect to="/" />
  } else {
    return <LoginForm />
  }
}

render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <Switch>
        <Route exact path="/" render={() => <App />} />
        <Route path="/login" render={loginFormOrRedirect} />
      </Switch>
    </ConnectedRouter>
  </Provider>,
  document.getElementById("app")
);
