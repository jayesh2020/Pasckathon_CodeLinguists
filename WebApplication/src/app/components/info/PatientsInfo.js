import React, { useState } from 'react';
import { setPatientInfo, setPatientUser } from '../../actions/info';
import { connect } from 'react-redux';
import { auth } from 'firebase';
import { Container } from 'react-bootstrap';
import { MDBContainer, MDBInput, MDBInputGroup } from 'mdbreact';
const PatientsInfo = ({
  auth,
  history,
  info,
  setPatientInfo,
  setPatientUser,
}) => {
  const [allergies, setAllergies] = useState('');
  const [bloodGroup, setBloodGroup] = useState('A+');
  const [height, setHeight] = useState('');
  const [weight, setWeight] = useState('');
  const [skinTone, setSkinTone] = useState('');
  const [otherDiseases, setOtherDiseases] = useState('');

  const onSubmit = (e) => {
    e.preventDefault();
    const patient = {
      allergies,
      bloodGroup,
      height,
      weight,
      skinTone,
      otherDiseases,
    };

    setPatientInfo(patient);
    const data = {
      ...patient,
      ...info.personalInfo,
      email: auth.user.email,
    };
    console.log(auth.uid);
    setPatientUser({ data, uid: auth.uid });
    setAllergies('');
    setBloodGroup('A+');
    setHeight('');
    setWeight('');
    setSkinTone('');
    setOtherDiseases('');
    history.push('patient/dashboard');
  };
  return (
    <div>
      <MDBContainer style={{ maxWidth: 600, marginTop: 20 }}>
        <form>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='md'
                label='Any Allergies'
                name='allergy'
                type='text'
                value={allergies}
                className='form-control'
                onChange={(e) => setAllergies(e.target.value)}
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInputGroup
                prepend='Blood Group'
                inputs={
                  <select
                    className='form-control browser-default custom-select'
                    id='bloodgroup'
                    value={bloodGroup}
                    onChange={(e) => setBloodGroup(e.target.value)}
                  >
                    <option value='A+'>A+</option>
                    <option value='A-'>A-</option>
                    <option value='B+'>B+</option>
                    <option value='B-'>B-</option>
                    <option value='O+'>O+</option>
                    <option value='O-'>O-</option>
                    <option value='AB+'>AB+</option>
                    <option value='AB-'>AB-</option>
                  </select>
                }
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='md'
                label='height'
                name='height'
                type='text'
                value={height}
                className='form-control'
                onChange={(e) => setHeight(e.target.value)}
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='md'
                label='weight'
                name='weight'
                type='text'
                value={weight}
                className='form-control'
                onChange={(e) => setWeight(e.target.value)}
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInputGroup
                prepend='Skin Tone'
                inputs={
                  <select
                    className='form-control browser-default custom-select'
                    id='skintone'
                    placeholder='Select Skin Tone'
                    value={skinTone}
                    onChange={(e) => setSkinTone(e.target.value)}
                  >
                    <option value='Fair'>Fair</option>
                    <option value='Medium'>Medium</option>
                    <option value='Dark'>Dark</option>
                  </select>
                }
              />
            </div>
          </div>
          <div className='form-group row'>
            <div className='col-sm-9'>
              <MDBInput
                outline
                size='md'
                label='Other Diseases'
                name='Diseases'
                type='text'
                value={otherDiseases}
                className='form-control'
                onChange={(e) => setOtherDiseases(e.target.value)}
              />
            </div>
          </div>
          <button onClick={onSubmit}>Submit</button>
        </form>
      </MDBContainer>
    </div>
  );
};

const mapStateToProps = (state) => ({
  info: state.info,
  auth: state.auth,
});

const mapDispatchToProps = (dispatch) => ({
  setPatientInfo: (patient) => dispatch(setPatientInfo(patient)),
  setPatientUser: (data) => dispatch(setPatientUser(data)),
});

export default connect(mapStateToProps, mapDispatchToProps)(PatientsInfo);
