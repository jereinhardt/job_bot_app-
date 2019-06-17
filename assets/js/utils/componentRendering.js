import React from "react";
import { Redirect } from "react-router-dom";
import { mainAppPath, resultsPath, rootPath } from "../routes.js";

export const resultsOrSearchPath = (store) => {
  if ( store.getState().listings.length > 0 ) {
    return resultsPath;
  } else {
    return mainAppPath;
  }
}

export const loggedOutComponent = (component, store) => {
  if ( store.getState().user.id == undefined ) {
    return component
  } else {
    return <Redirect to={resultsOrSearchPath(store)} />    
  }
}

export const loggedInComponent = (component, store) => {
  if ( store.getState().user.id ) {
    return  component
  } else {
    return <Redirect to={rootPath} />
  }
}