import React, { useState } from 'react';
import { setPatientInfo,setPatientUser } from '../../actions/info';
import { connect } from 'react-redux';
import { auth } from 'firebase';
import { Container } from 'react-bootstrap';

const PatientsInfo = ({auth, info, setPatientInfo,setPatientUser}) => {
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
      otherDiseases
    };
    
    setPatientInfo(patient);
    const data = {
      ...patient,
      ...info.personalInfo,
      email: auth.user.email
    }
    console.log(auth.uid);
    setPatientUser({data,uid: auth.uid});
    setAllergies('');
    setBloodGroup('A+');
    setHeight('');
    setWeight('');
    setSkinTone('');
    setOtherDiseases('');
  };
  return (
    <div>
      <Container style={{maxWidth:600, marginTop:20}}>
      <form>
      <div class="form-group row">
          <label for="city" class="col-sm-3 col-form-label">Any Allergies</label>
          <div className="col-sm-9">
          <input
            name="allergies"
            type='text'
            value={allergies}
            className="form-control"
            onChange={(e) => setAllergies(e.target.value)}
          />
          </div>
        </div>
        <div class="form-group row">
          <label for="exampleFormControlSelect1" class="col-sm-3 col-form-label">Blood Group</label>
          <div className="col-sm-9">
          <select class="form-control" id="exampleFormControlSelect1" value={bloodGroup} onChange={(e) => setBloodGroup(e.target.value)}>
            <option value='A+'>A+</option>
            <option value='A-'>A-</option>
            <option value='B+'>B+</option>
            <option value='B-'>B-</option>
            <option value='O+'>O+</option>
            <option value='O-'>O-</option>
            <option value='AB+'>AB+</option>
            <option value='AB-'>AB-</option>
          </select>
          </div>
        </div>
        <div class="form-group row">
          <label for="height" class="col-sm-3 col-form-label">Height</label>
          <div className="col-sm-9">
          <input
            name="height"
            type='text'
            value={height}
            className="form-control"
            onChange={(e) => setHeight(e.target.value)}
          />
          </div>
        </div>
        <div class="form-group row">
          <label for="weight" class="col-sm-3 col-form-label">Weight</label>
          <div className="col-sm-9">
          <input
            name="weight"
            type='text'
            value={weight}
            className="form-control"
            onChange={(e) => setWeight(e.target.value)}
          />
          </div>
        </div>
        <div class="form-group row">
          <label for="skintone" class="col-sm-3 col-form-label">Skin Tone</label>
          <div className="col-sm-9">
          <select class="form-control" id="skintone" placeholder="Select Skin Tone" value={skinTone} onChange={(e) => setSkinTone(e.target.value)}>
            <option value='Fair'>Fair</option>
            <option value='Medium'>Medium</option>
            <option value='Dark'>Dark</option>
          </select>
          </div>
        </div>
      
        <div>
          <input
            type='text'
            value={otherDiseases}
            onChange={(e) => setOtherDiseases(e.target.value)}
          />
        </div>
        <button onClick={onSubmit}>Next</button>
      </form>
      </Container>
    </div>
  );
};

const mapStateToProps = state => ({
  info : state.info,
  auth: state.auth
});

const mapDispatchToProps = (dispatch) => ({
  setPatientInfo: (patient) => dispatch(setPatientInfo(patient)),
  setPatientUser: (data) => dispatch(setPatientUser(data))
});

export default connect(mapStateToProps,mapDispatchToProps)(PatientsInfo);
