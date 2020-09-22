import React, { Component } from 'react';
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
import { BrowserRouter as Router } from 'react-router-dom';

class NavbarPage extends Component {
  state = {
    isOpen: false,
  };

  toggleCollapse = () => {
    this.setState({ isOpen: !this.state.isOpen });
  };

  render() {
    return (
      <Router>
        <MDBNavbar color='orange' dark expand='md'>
          <MDBNavbarBrand>
            <strong className='white-text text-sm-center'>
              DERMO SOLUTIONS
            </strong>
          </MDBNavbarBrand>
          <MDBNavbarToggler onClick={this.toggleCollapse} />
          <MDBCollapse id='navbarCollapse3' isOpen={this.state.isOpen} navbar>
            <MDBNavbarNav left>
              <MDBNavItem active>
                <MDBNavLink to='#!'>Dashboard</MDBNavLink>
              </MDBNavItem>
              <MDBNavItem>
                <MDBNavLink to='#!'>Doctors</MDBNavLink>
              </MDBNavItem>
              <MDBNavItem>
                <MDBNavLink to='#!'>Pricing</MDBNavLink>
              </MDBNavItem>
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
                    <MDBDropdownItem href='#!'>Sign Out</MDBDropdownItem>
                  </MDBDropdownMenu>
                </MDBDropdown>
              </MDBNavItem>
            </MDBNavbarNav>
          </MDBCollapse>
        </MDBNavbar>
      </Router>
    );
  }
}

export default NavbarPage;
