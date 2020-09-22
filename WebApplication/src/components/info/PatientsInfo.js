import React, { useState } from 'react';
import { setPatientInfo,setPatientUser } from '../../actions/info';
import { connect } from 'react-redux';
import { auth } from 'firebase';

const PatientsInfo = ({auth, info, setPatientInfo,setPatientUser}) => {
  const [allergies, setAllergies] = useState('');
  const [bloodGroup, setBloodGroup] = useState('');
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
    setBloodGroup('');
    setHeight('');
    setWeight('');
    setSkinTone('');
    setOtherDiseases('');
  };
  return (
    <div>
      <form>
        <div>
          <input
            type='text'
            value={allergies}
            onChange={(e) => setAllergies(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={bloodGroup}
            onChange={(e) => setBloodGroup(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={height}
            onChange={(e) => setHeight(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={weight}
            onChange={(e) => setWeight(e.target.value)}
          />
        </div>
        <div>
          <input
            type='text'
            value={skinTone}
            onChange={(e) => setSkinTone(e.target.value)}
          />
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
