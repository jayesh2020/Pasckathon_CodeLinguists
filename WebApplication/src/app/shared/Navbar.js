import React, { Component, Fragment, useState } from 'react';
import './navbar.scss';
import {
  MDBNavbar,
  MDBNavbarBrand,
  MDBNavbarNav,
  MDBNavItem,
  MDBNavLink,
  MDBNavbarToggler,
  MDBCollapse,
  MDBDropdown,
  MDBDropdownToggle,
  MDBDropdownMenu,
  MDBDropdownItem,
  MDBIcon,
} from 'mdbreact';
import { auth } from '../firebase/firebase';
import { BrowserRouter as Router } from 'react-router-dom';
import { connect } from 'react-redux';
import { NavLink } from 'react-router-dom';

const NavbarPage = ({ history, user }) => {
  const [state, setState] = useState({
    isOpen: false,
  });
  const toggleCollapse = () => {
    setState({ isOpen: !this.state.isOpen });
  };

  return (
    <Router>
      <MDBNavbar color='orange' dark expand='md'>
        <MDBNavbarBrand>
          <strong className='white-text text-sm-center'>DERMO SOLUTIONS</strong>
        </MDBNavbarBrand>
        <MDBNavbarToggler onClick={toggleCollapse} />
        <MDBCollapse id='navbarCollapse3' isOpen={state.isOpen} navbar>
          <MDBNavbarNav left>
            <MDBNavItem active>
              {user &&
                (user.role == 'doctor' ? (
                  <MDBNavLink
                    onClick={(e) => {
                      e.preventDefault();
                      history.push('/doctor/dashboard');
                    }}
                    to='/doctor/dashboard'
                  >
                    Dashboard
                  </MDBNavLink>
                ) : (
                  <MDBNavLink
                    onClick={(e) => {
                      e.preventDefault();
                      history.push('/dashboard');
                    }}
                    to='/dashboard'
                  >
                    Dashboard
                  </MDBNavLink>
                ))}
            </MDBNavItem>
            {auth.user && user.role == 'patient' && (
              <Fragment>
                <MDBNavItem>
                  <MDBNavLink
                    onClick={(e) => {
                      e.preventDefault();
                      history.push('/imagetest');
                    }}
                    to='/imagetest'
                  >
                    Test
                  </MDBNavLink>
                </MDBNavItem>
                <MDBNavItem>
                  <MDBNavLink to='/doctorsearch'>Doctor Search</MDBNavLink>
                </MDBNavItem>
              </Fragment>
            )}
          </MDBNavbarNav>
          <MDBNavbarNav right>
            <MDBNavItem>
              <MDBNavLink className='waves-effect waves-light' to='#!'>
                <i className='fas fa-bell'></i>
              </MDBNavLink>
            </MDBNavItem>
            <MDBNavItem>
              <MDBDropdown>
                <MDBDropdownToggle nav caret>
                  <MDBIcon icon='user' />
                </MDBDropdownToggle>
                <MDBDropdownMenu right className='dropdown-default '>
                  <MDBDropdownItem href='#!'>Reset Password</MDBDropdownItem>
                  <MDBDropdownItem
                    onClick={(e) => {
                      e.preventDefault();
                      auth.signOut();
                      window.location.reload(true);
                    }}
                  >
                    Sign Out
                  </MDBDropdownItem>
                </MDBDropdownMenu>
              </MDBDropdown>
            </MDBNavItem>
          </MDBNavbarNav>
        </MDBCollapse>
      </MDBNavbar>
    </Router>
  );
};

const mapStateToProps = (state) => ({
  user: state.auth.user,
});

export default connect(mapStateToProps)(NavbarPage);
