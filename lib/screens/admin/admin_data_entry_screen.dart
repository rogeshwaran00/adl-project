import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_theme.dart';

class AdminDataEntryScreen extends StatefulWidget {
  const AdminDataEntryScreen({super.key});

  @override
  State<AdminDataEntryScreen> createState() => _AdminDataEntryScreenState();
}

class _AdminDataEntryScreenState extends State<AdminDataEntryScreen> {
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _villageCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _landLocationCtrl = TextEditingController();
  final _landAreaCtrl = TextEditingController();
  final _loanAmountCtrl = TextEditingController();
  String _loanPurpose = '';
  String _assignedOfficer = '';
  DateTime? _disbursementDate;
  DateTime? _deadline;
  bool _showSuccess = false;

  bool get _isFormValid =>
      _nameCtrl.text.isNotEmpty &&
      _mobileCtrl.text.length == 10 &&
      _addressCtrl.text.isNotEmpty &&
      _villageCtrl.text.isNotEmpty &&
      _districtCtrl.text.isNotEmpty &&
      _stateCtrl.text.isNotEmpty &&
      _pincodeCtrl.text.length == 6 &&
      _landLocationCtrl.text.isNotEmpty &&
      _loanAmountCtrl.text.isNotEmpty &&
      _loanPurpose.isNotEmpty &&
      _assignedOfficer.isNotEmpty &&
      _disbursementDate != null &&
      _deadline != null;

  void _resetForm() {
    _nameCtrl.clear(); _mobileCtrl.clear(); _addressCtrl.clear();
    _villageCtrl.clear(); _districtCtrl.clear(); _stateCtrl.clear();
    _pincodeCtrl.clear(); _landLocationCtrl.clear(); _landAreaCtrl.clear();
    _loanAmountCtrl.clear();
    setState(() { _loanPurpose = ''; _assignedOfficer = ''; _disbursementDate = null; _deadline = null; });
  }

  void _handleSubmit() {
    setState(() => _showSuccess = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showSuccess = false);
        _resetForm();
      }
    });
  }

  Future<void> _pickDate(bool isDisbursement) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isDisbursement) _disbursementDate = picked;
        else _deadline = picked;
      });
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'Select date';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _mobileCtrl, _addressCtrl, _villageCtrl, _districtCtrl, _stateCtrl, _pincodeCtrl, _landLocationCtrl, _landAreaCtrl, _loanAmountCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  label: const Text('Back to Dashboard', style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
                const SizedBox(height: 16),
                const Text('Admin Data Entry',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                Text('Add new beneficiary & loan details',
                    style: TextStyle(color: Colors.purple[100], fontSize: 13)),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success banner
                  if (_showSuccess)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: AppTheme.green600, size: 24),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Beneficiary Added Successfully!',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF14532D))),
                              Text('Loan record has been created',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF15803D))),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // --- BENEFICIARY INFO ---
                  _sectionHeader(Icons.person_add, 'Beneficiary Information'),
                  const SizedBox(height: 16),
                  _field('Full Name *', _nameCtrl, 'Enter beneficiary\'s full name'),
                  _field('Mobile Number *', _mobileCtrl, '10-digit mobile number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)]),
                  _field('Address *', _addressCtrl, 'Enter beneficiary\'s address'),
                  _field('Village *', _villageCtrl, 'Enter beneficiary\'s village'),
                  _field('District *', _districtCtrl, 'Enter beneficiary\'s district'),
                  _field('State *', _stateCtrl, 'Enter beneficiary\'s state'),
                  _field('Pincode *', _pincodeCtrl, '6-digit pincode',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)]),
                  _field('Land Location *', _landLocationCtrl, 'Enter land location'),
                  _field('Land Area (sq. ft.)', _landAreaCtrl, 'Enter land area',
                      keyboardType: TextInputType.number),

                  const Divider(height: 32),

                  // --- LOAN DETAILS ---
                  _sectionHeader(Icons.currency_rupee, 'Loan Details'),
                  const SizedBox(height: 16),
                  _field('Loan Amount (₹) *', _loanAmountCtrl, 'Enter loan amount',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  const Text('Loan Purpose *',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.gray700)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _loanPurpose.isEmpty ? null : _loanPurpose,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.gray200, width: 2)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.gray200, width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.purple600, width: 2)),
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    hint: const Text('Select purpose', style: TextStyle(fontSize: 13)),
                    items: ['Agricultural Equipment', 'Dairy Equipment', 'Food Processing Unit', 'Warehouse Construction', 'Irrigation System', 'Farm Machinery', 'Livestock Purchase', 'Other']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => setState(() => _loanPurpose = v ?? ''),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _datePicker('Disbursement Date *', _disbursementDate, () => _pickDate(true))),
                      const SizedBox(width: 12),
                      Expanded(child: _datePicker('Deadline *', _deadline, () => _pickDate(false))),
                    ],
                  ),

                  const Divider(height: 32),

                  // --- OFFICER ASSIGNMENT ---
                  _sectionHeader(Icons.manage_accounts, 'Officer Assignment'),
                  const SizedBox(height: 16),
                  const Text('Assign to Officer *',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.gray700)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _assignedOfficer.isEmpty ? null : _assignedOfficer,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.gray200, width: 2)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.gray200, width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.purple600, width: 2)),
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    hint: const Text('Select officer', style: TextStyle(fontSize: 13)),
                    items: [
                      'Officer Sharma (OFF001) - Delhi Region',
                      'Officer Kumar (OFF002) - Delhi Region',
                      'Officer Verma (OFF003) - Haryana Region',
                      'Officer Singh (OFF004) - Haryana Region',
                      'Officer Patel (OFF005) - UP Region',
                    ].map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (v) => setState(() => _assignedOfficer = v ?? ''),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Note:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF581C87))),
                        const SizedBox(height: 16),
                        for (final note in [
                          'Beneficiary will receive SMS notification',
                          'Officer will be notified of new assignment',
                          'Loan ID will be auto-generated',
                          'Deadline should be 60-90 days from disbursement',
                        ])
                          Text('• $note', style: const TextStyle(fontSize: 11, color: Color(0xFF7E22CE), height: 1.7)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: _isFormValid ? AppGradients.purpleHeader : null,
                      color: _isFormValid ? null : AppTheme.gray200,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _isFormValid
                          ? [BoxShadow(color: AppTheme.purple600.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                          : null,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isFormValid ? _handleSubmit : null,
                      icon: Icon(Icons.save, color: _isFormValid ? Colors.white : AppTheme.gray500),
                      label: Text('Save Beneficiary',
                          style: TextStyle(color: _isFormValid ? Colors.white : AppTheme.gray500)),
                      style: AppTheme.elevatedOnGradient(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.purple600),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.gray800)),
      ],
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.gray700)),
          const SizedBox(height: 16),
          TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.gray200, width: 2)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.purple600, width: 2)),
              filled: true, fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePicker(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.gray700)),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.gray200, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppTheme.gray400),
                const SizedBox(width: 6),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: date == null ? AppTheme.gray400 : AppTheme.gray800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
