import React, { Component } from 'react';
import { Route, Redirect } from 'react-router-dom';
import { connect } from 'react-redux';

export const PublicRoute = ({
    isAuthenticated,
    user,
    component: Component,
    ...rest
}) => (
    <Route {...rest} component={(props) => (
        !isAuthenticated ? (
            <div>
                <Component {...props} />
            </div>
        ) : (
            (user) && (user.role=="patient" ? <Redirect to='/dashboard' />:<Redirect to='/doctor/dashboard' />)
            
        )
    )} />
);

const mapStateToProps = (state) => ({
    isAuthenticated : state.auth.isAuthenticated,
    user: state.auth.user
});

export default connect(mapStateToProps)(PublicRoute);