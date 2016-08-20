//
//  Macros.h
//  TableView2
//
//  Created by Чернов Николай on 8/17/16.
//  Copyright © 2016 Чернов Николай. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#ifdef __OBJC__

#define SELF_KEY_PATH(PATH) OBJECT_KEY_PATH(self, PATH)
#define OBJECT_KEY_PATH(OBJECT, PATH) TYPE_KEY_PATH(typeof(*(OBJECT)), PATH)
#define TYPE_KEY_PATH(TYPE, PATH) (((void)(NO && ((void)((TYPE *)nil).PATH, NO)), # PATH))

#endif /* __OBJC__ */

#endif /* Macros_h */
