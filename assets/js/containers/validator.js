// import React from "react";

export default class Validator {
  constructor(component, validations) {
    this.component = component;
    this.validations = validations;
    this.errors = [];
  }

  hasInvalidFields() {
    this.errors = [];
    const invalidProperties = this.validations.filter((validation) => {
      return this._inputIsInvalid(validation);
    });
    if (invalidProperties.length > 0) {
      this.errors = invalidProperties.map(({ id, validate }) => {
        const value = this.component.state[id];
        const errorProperty = validate.
          find((validation) => this._inputIsInvalidFor(value, validation));
        return {id: id, message: this._errorMessageFor(errorProperty)};
      });
      this.component.forceUpdate();
      return true;
    } else {
      return false;
    }
  }

  errorClassFor(name) {
    const title = this.errors.some(({ id }) => id == name) ? "has-error" : "";
    return title;
  }

  errorMessageFor(name) {
    const validation = this.errors.find(({ id }) => id == name)
    if ( validation ) {
      return validation.message;
    } else {
      return "";
    }
  }

  _inputIsInvalid({ id, validate }) {
    const value = this.component.state[id];
    return validate.some((validation) => {
      return this._inputIsInvalidFor(value, validation)
    });
  }

  _inputIsInvalidFor(value, validation) {
    return this._validations()[validation](value);
  }

  _validations() {
    return {
      "presence": this._invalidPresence,
      "email": this._invalidEmail
    }
  }

  _invalidPresence(value) {
    return (value == "" || value == undefined);
  }

  _invalidEmail(value) {
    const regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return !regex.test(String(value).toLowerCase());
  }

  _errorMessageFor(validation) {
    const messages = {
      "presence": "Cannot be blank",
      "email": "Must be a valid email address"
    };

    return messages[validation];
  }
}