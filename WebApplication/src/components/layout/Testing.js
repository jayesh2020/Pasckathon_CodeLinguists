import { PDFDownloadLink, Document, Page,Text } from '@react-pdf/renderer'
import React from 'react';
import Report from '../consult/Report';
import { connect } from 'react-redux';

const Applic = ({ doctorSearch }) => (
  <div>
    <PDFDownloadLink document={<Report />} fileName="somename.pdf">
      {({ blob, url, loading, error }) => (loading ? 'Loading document...' : url)}
    </PDFDownloadLink>
  </div>
);

const mapStateToProps = state => ({
    doctorSearch: state.doctorSearch
})

export default connect(mapStateToProps)(Applic);