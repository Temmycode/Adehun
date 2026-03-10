class MockData {
  MockData._();

  // User
  static const String userName = 'Temi Akisanya';
  static const String userEmail = 'temi@example.com';
  static const String userPhone = '+234 812 345 6789';
  static const String userInitials = 'TA';
  static const String userTier = 'Free';

  // Wallet
  static const double walletBalance = 250000.00;
  static const String walletCurrency = '\u20A6'; // Naira symbol

  // Agreements
  static const List<Map<String, dynamic>> agreements = [
    {
      'id': '1',
      'title': 'Website Redesign Project',
      'description':
          'Complete redesign of corporate website including mobile responsiveness, new branding, and CMS integration.',
      'amount': 150000.0,
      'status': 'ACTIVE',
      'depositor': {
        'id': 'p1',
        'name': 'Temi Akisanya',
        'initials': 'TA',
        'role': 'depositor',
      },
      'beneficiary': {
        'id': 'p2',
        'name': 'Adebayo Johnson',
        'initials': 'AJ',
        'role': 'beneficiary',
      },
      'createdAt': '2025-03-01',
      'conditions': [
        {
          'id': 'c1',
          'title': 'Homepage Design Mockup',
          'description': 'Deliver the homepage design mockup in Figma',
          'status': 'MET',
          'requiredFrom': {
            'id': 'p2',
            'name': 'Adebayo Johnson',
            'initials': 'AJ',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p1',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'depositor',
          },
          'assets': [
            {
              'id': 'a1',
              'name': 'homepage_v2.fig',
              'type': 'file',
              'status': 'APPROVED',
            },
            {
              'id': 'a2',
              'name': 'design_preview.png',
              'type': 'image',
              'status': 'APPROVED',
            },
          ],
        },
        {
          'id': 'c2',
          'title': 'Mobile Responsive Implementation',
          'description': 'Website must be fully responsive on all device sizes',
          'status': 'IN_PROGRESS',
          'requiredFrom': {
            'id': 'p2',
            'name': 'Adebayo Johnson',
            'initials': 'AJ',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p1',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'depositor',
          },
          'assets': [
            {
              'id': 'a3',
              'name': 'mobile_screenshots.zip',
              'type': 'file',
              'status': 'PENDING',
            },
          ],
        },
        {
          'id': 'c3',
          'title': 'CMS Integration',
          'description': 'WordPress CMS setup with custom theme',
          'status': 'PENDING',
          'requiredFrom': {
            'id': 'p2',
            'name': 'Adebayo Johnson',
            'initials': 'AJ',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p2',
            'name': 'Adebayo Johnson',
            'initials': 'AJ',
            'role': 'beneficiary',
          },
          'assets': [],
        },
      ],
    },
    {
      'id': '2',
      'title': 'Logo Design',
      'description': 'Brand logo design with 3 concepts and 2 revision rounds.',
      'amount': 50000.0,
      'status': 'CONDITIONS_MET',
      'depositor': {
        'id': 'p3',
        'name': 'Funke Adeleke',
        'initials': 'FA',
        'role': 'depositor',
      },
      'beneficiary': {
        'id': 'p4',
        'name': 'Temi Akisanya',
        'initials': 'TA',
        'role': 'beneficiary',
      },
      'createdAt': '2025-02-20',
      'conditions': [
        {
          'id': 'c4',
          'title': '3 Logo Concepts',
          'description': 'Deliver 3 different logo concepts',
          'status': 'MET',
          'requiredFrom': {
            'id': 'p4',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p3',
            'name': 'Funke Adeleke',
            'initials': 'FA',
            'role': 'depositor',
          },
          'assets': [
            {
              'id': 'a4',
              'name': 'logo_concepts.pdf',
              'type': 'file',
              'status': 'APPROVED',
            },
          ],
        },
        {
          'id': 'c5',
          'title': 'Final Logo Package',
          'description': 'Deliver final logo in all formats (PNG, SVG, AI)',
          'status': 'MET',
          'requiredFrom': {
            'id': 'p4',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p3',
            'name': 'Funke Adeleke',
            'initials': 'FA',
            'role': 'depositor',
          },
          'assets': [
            {
              'id': 'a5',
              'name': 'final_logo_pack.zip',
              'type': 'file',
              'status': 'APPROVED',
            },
          ],
        },
      ],
    },
    {
      'id': '3',
      'title': 'Mobile App Development',
      'description':
          'Develop a Flutter mobile app for inventory management with offline support.',
      'amount': 500000.0,
      'status': 'PENDING_ACCEPTANCE',
      'depositor': {
        'id': 'p5',
        'name': 'Temi Akisanya',
        'initials': 'TA',
        'role': 'depositor',
      },
      'beneficiary': {
        'id': 'p6',
        'name': 'Chinedu Okafor',
        'initials': 'CO',
        'role': 'beneficiary',
      },
      'createdAt': '2025-03-05',
      'conditions': [
        {
          'id': 'c6',
          'title': 'UI/UX Design Approval',
          'description': 'Complete UI/UX design in Figma for approval',
          'status': 'PENDING',
          'requiredFrom': {
            'id': 'p6',
            'name': 'Chinedu Okafor',
            'initials': 'CO',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p5',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'depositor',
          },
          'assets': [],
        },
        {
          'id': 'c7',
          'title': 'MVP Delivery',
          'description': 'Deliver working MVP with core features',
          'status': 'PENDING',
          'requiredFrom': {
            'id': 'p6',
            'name': 'Chinedu Okafor',
            'initials': 'CO',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p5',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'depositor',
          },
          'assets': [],
        },
      ],
    },
    {
      'id': '4',
      'title': 'Content Writing',
      'description': '10 blog articles for tech startup, SEO optimized.',
      'amount': 75000.0,
      'status': 'COMPLETED',
      'depositor': {
        'id': 'p7',
        'name': 'Ngozi Eze',
        'initials': 'NE',
        'role': 'depositor',
      },
      'beneficiary': {
        'id': 'p8',
        'name': 'Temi Akisanya',
        'initials': 'TA',
        'role': 'beneficiary',
      },
      'createdAt': '2025-01-15',
      'conditions': [
        {
          'id': 'c8',
          'title': 'Article Delivery',
          'description': 'All 10 articles delivered and approved',
          'status': 'MET',
          'requiredFrom': {
            'id': 'p8',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p7',
            'name': 'Ngozi Eze',
            'initials': 'NE',
            'role': 'depositor',
          },
          'assets': [
            {
              'id': 'a6',
              'name': 'articles_batch.zip',
              'type': 'file',
              'status': 'APPROVED',
            },
          ],
        },
      ],
    },
    {
      'id': '5',
      'title': 'Social Media Graphics',
      'description': 'Monthly social media graphics package - 30 designs.',
      'amount': 35000.0,
      'status': 'DISPUTED',
      'depositor': {
        'id': 'p9',
        'name': 'Temi Akisanya',
        'initials': 'TA',
        'role': 'depositor',
      },
      'beneficiary': {
        'id': 'p10',
        'name': 'Bola Ogunleye',
        'initials': 'BO',
        'role': 'beneficiary',
      },
      'createdAt': '2025-02-10',
      'conditions': [
        {
          'id': 'c9',
          'title': '30 Social Media Designs',
          'description': 'Deliver 30 unique social media post designs',
          'status': 'IN_PROGRESS',
          'requiredFrom': {
            'id': 'p10',
            'name': 'Bola Ogunleye',
            'initials': 'BO',
            'role': 'beneficiary',
          },
          'addedBy': {
            'id': 'p9',
            'name': 'Temi Akisanya',
            'initials': 'TA',
            'role': 'depositor',
          },
          'assets': [
            {
              'id': 'a7',
              'name': 'batch_1_designs.zip',
              'type': 'file',
              'status': 'REJECTED',
            },
          ],
        },
      ],
    },
    {
      'id': '6',
      'title': 'Video Editing Project',
      'description': 'Edit a 15-minute promotional video with motion graphics.',
      'amount': 120000.0,
      'status': 'DRAFT',
      'depositor': {
        'id': 'p11',
        'name': 'Temi Akisanya',
        'initials': 'TA',
        'role': 'depositor',
      },
      'beneficiary': {
        'id': '',
        'name': '',
        'initials': '',
        'role': 'beneficiary',
      },
      'createdAt': '2025-03-07',
      'conditions': [],
    },
  ];

  // Transactions
  static const List<Map<String, dynamic>> transactions = [
    {
      'id': 't1',
      'type': 'DEPOSIT',
      'amount': 150000.0,
      'description': 'Funded wallet',
      'date': '2025-03-06',
      'status': 'COMPLETED',
    },
    {
      'id': 't2',
      'type': 'ESCROW_LOCK',
      'amount': -150000.0,
      'description': 'Escrow: Website Redesign Project',
      'date': '2025-03-01',
      'status': 'COMPLETED',
    },
    {
      'id': 't3',
      'type': 'RECEIVED',
      'amount': 75000.0,
      'description': 'Escrow: Content Writing — Funds Released',
      'date': '2025-02-28',
      'status': 'COMPLETED',
    },
    {
      'id': 't4',
      'type': 'DEPOSIT',
      'amount': 200000.0,
      'description': 'Funded wallet',
      'date': '2025-02-15',
      'status': 'COMPLETED',
    },
    {
      'id': 't5',
      'type': 'ESCROW_LOCK',
      'amount': -35000.0,
      'description': 'Escrow: Social Media Graphics',
      'date': '2025-02-10',
      'status': 'COMPLETED',
    },
    {
      'id': 't6',
      'type': 'DEPOSIT',
      'amount': 100000.0,
      'description': 'Funded wallet',
      'date': '2025-01-20',
      'status': 'COMPLETED',
    },
  ];

  // Notifications
  static const List<Map<String, dynamic>> notifications = [
    {
      'id': 'n1',
      'type': 'INVITATION',
      'title': 'New Agreement Invitation',
      'message': 'Chinedu Okafor invited you to "Mobile App Development"',
      'timestamp': '2025-03-07 14:30',
      'read': false,
    },
    {
      'id': 'n2',
      'type': 'CONDITION_UPDATE',
      'title': 'Condition Updated',
      'message':
          'A new asset was uploaded for "Mobile Responsive Implementation"',
      'timestamp': '2025-03-06 09:15',
      'read': false,
    },
    {
      'id': 'n3',
      'type': 'APPROVAL',
      'title': 'Asset Approved',
      'message': 'Your asset "homepage_v2.fig" was approved',
      'timestamp': '2025-03-05 16:45',
      'read': true,
    },
    {
      'id': 'n4',
      'type': 'PAYMENT',
      'title': 'Funds Released',
      'message':
          '\u20A675,000.00 released to your wallet from "Content Writing"',
      'timestamp': '2025-02-28 11:00',
      'read': true,
    },
    {
      'id': 'n5',
      'type': 'DISPUTE',
      'title': 'Dispute Raised',
      'message': 'A dispute has been raised on "Social Media Graphics"',
      'timestamp': '2025-02-25 08:30',
      'read': true,
    },
    {
      'id': 'n6',
      'type': 'REMINDER',
      'title': 'Pending Acceptance',
      'message':
          '"Mobile App Development" is waiting for acceptance from Chinedu Okafor',
      'timestamp': '2025-03-06 10:00',
      'read': true,
    },
  ];
}
