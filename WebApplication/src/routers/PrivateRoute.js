import React, { Component } from 'react';
import { Route, Redirect } from 'react-router-dom';
import { connect } from 'react-redux';

export const PrivateRoute = ({
    isAuthenticated,
    component: Component,
    ...rest
}) => (
    <Route {...rest} component={(props) => (
        isAuthenticated ? (
            <div>
                <Component {...props} />
            </div>
        ) : (
            <Redirect to="/login" />
        )
    )} />
);

const mapStateToProps = (state) => ({
    isAuthenticated : state.auth.isAuthenticated
});

export default connect(mapStateToProps)(PrivateRoute);