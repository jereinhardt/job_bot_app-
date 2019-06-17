import $ from "jquery";
import { createBrowserHistory } from "history";
import { applyMiddleware, compose, createStore } from "redux";
import { routerMiddleware } from "connected-react-router";
import { sourcesPath, userDataPath, userListingsPath } from "./routes.js";
import createRootReducer from "./reducer.js";

export const history = createBrowserHistory();
const middleware = applyMiddleware(routerMiddleware(history));

export const initializeStore = (state) => {
  const defaults = {activeStep: 1, applicantLocation: "", location: "", terms: ""};
  const initialState = Object.assign({}, defaults, state);

  return createStore(
    createRootReducer(history),
    initialState,
    compose(middleware)
  );
}